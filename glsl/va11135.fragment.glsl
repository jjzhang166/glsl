//using the endpoint of a fractal to get pixel from a texture is called orbit trap / bitmap orbit trap

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform sampler2D backbuffer; 

//######################### flower like lines


#ifdef GL_ES
precision mediump float;
#endif

//uniform float time;
//uniform vec2 mouse;
//uniform vec2 resolution;
//uniform sampler2D backbuffer;
#define pi 3.141592653589793238462643383279
#define pi_inv 0.318309886183790671537767526745
#define pi2_inv 0.159154943091895335768883763372 

/// bipolar complex by @Flexi23
/// "logarithmic zoom with a spiral twist and a division by zero in the complex number plane." (from https://www.shadertoy.com/view/4ss3DB)

vec2 complex_mul(vec2 factorA, vec2 factorB){
  return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

vec2 wrap_flip(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}
 
float border(vec2 domain, float thickness){
   vec2 uv = fract(domain-vec2(0.5));
   uv = min(uv,1.-uv)*2.;
   return clamp(max(uv.x,uv.y)-1.+thickness,0.,1.)/(thickness);
}

float circle(vec2 uv, vec2 aspect, float scale){
	return clamp( 1. - length((uv-0.5)*aspect*scale), 0., 1.);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, vec2 center, vec2 aspect, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - center) * aspect) - radius) * sharpness) * 0.5;
}

float lum(vec3 color){
	return dot(vec3(0.30, 0.59, 0.11), color);
}

vec2 spiralzoom(vec2 domain, vec2 center, float n, float spiral_factor, float zoom_factor, vec2 pos){
	vec2 uv = domain - center;
	float angle = atan(uv.y, uv.x);
	float d = length(uv);
	return vec2( angle*n*pi2_inv + log(d)*spiral_factor, -log(d)*zoom_factor + 0.*n*angle*pi2_inv) + pos;
}

vec2 mobius(vec2 domain, vec2 zero_pos, vec2 asymptote_pos){
	return complex_div( domain - zero_pos, domain - asymptote_pos);
}

/// basically just a lookup from a texture with GL_LINEAR (instead of the active GL_NEAREST method for the backbuffer) resembled in shader code - surely not very efficient, but hey it looks much better and works on Float32 textures too!
vec4 bilinear(sampler2D sampler, vec2 uv, vec2 resolution){
	vec2 pixelsize = 1./resolution;
	vec2 pixel = uv * resolution;
	vec2 d = pixel - floor(pixel) + 0.5;
	pixel = (pixel - d)*pixelsize;
	
	vec2 h = vec2( pixel.x, pixel.x + pixelsize.x);
	if(d.x < 0.5)
		h = vec2( pixel.x, pixel.x - pixelsize.x);
	
	vec2 v = vec2( pixel.y, pixel.y + pixelsize.y);
	if(d.y < 0.5)
		v = vec2( pixel.y, pixel.y - pixelsize.y);
	
	vec4 lowerleft = texture2D(sampler, vec2(h.x, v.x));
	vec4 upperleft = texture2D(sampler, vec2(h.x, v.y));
	vec4 lowerright = texture2D(sampler, vec2(h.y, v.x));
	vec4 upperright = texture2D(sampler, vec2(h.y, v.y));
	
	d = abs(d - 0.5);
	
	return mix( mix( lowerleft, lowerright, d.x), mix( upperleft, upperright, d.x),	d.y);
}

vec4 mainFlower(vec2 pEnd)
{
	// domain map
	//vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 uv = pEnd;
	
	// aspect-ratio correction
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv_correct = 0.5 + (uv -0.5)/ aspect.yx;
	vec2 mouse_correct = 0.5 + ( mouse.xy / resolution.xy - 0.5) / aspect.yx;
		
	float phase = time*0. + pi*1.;
	float dist = 0.68;
	vec2 uv_bipolar = mobius(uv_correct, vec2(0.5 - dist*0.5, 0.5), vec2(0.5 + dist*0.5, 0.5));
	uv_bipolar = spiralzoom(uv_bipolar, vec2(0.), 10., -0.5, .50, mouse.yx*vec2(-1.,1.)*10.);
	//uv_bipolar = vec2(-uv_bipolar.y,uv_bipolar.x); // 90° rotation 
	
	vec2 uv_trace = wrap_flip(uv_bipolar);

	vec2 pos = uv_trace;
	float amnt = 70.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<5.0;i++){
	nd =sin(3.14*0.8*pos.x + (i*0.1+sin(+time)*0.4) + time)*0.4+0.1 + pos.x;
	amnt = 1.0/abs(nd-pos.y)*0.01; 
	
	cbuff += vec4(amnt, amnt*0.3 , amnt*pos.y, 081.0);
	}
	
	for(float i=0.0; i<1.0;i++){
	nd =sin(3.14*2.0*pos.y + i*40.5 + time)*90.3*(pos.y+80.3)+0.5;
	amnt = 1.0/abs(nd-pos.x)*0.015;
	
	cbuff += vec4(amnt*0.2, amnt*0.2 , amnt*pos.x, 1.0);
	}
	
	float foo = 1.0;
	float bar = 12./256.;
	float baz = 1.08;
	float w = -pi*1.*1.61803;
	vec2 rot = vec2( cos(w), sin(w));
	vec2 drop = 0.5 + complex_mul((uv - 0.5)*aspect, rot)*baz/aspect;
//	drop = wrap_flip(drop);
	drop = clamp(drop, 0., 1.);
	
	vec4 dbuff =  bilinear(backbuffer,drop, resolution)*foo - bar;
 
	vec4 outColor = mix(cbuff, vec4(1),  dbuff * (1. - border(drop, 0.5)));
	//gl_FragColor = mix(gl_FragColor, vec4(1),  border(pos, 0.1)*0.5);
	outColor.w = 1.;
	return outColor;
}

//############################################## HEART
vec3 mainHeart(vec2 p)
{
	p += - vec2(1.0,0.55);
	p *= 1.3;
	p.y -= 0.25;
	
	// background color
	vec3 bcol = vec3(0.4,1.0,0.7-0.07*p.y)*(1.0-0.25*length(p));
	
	
	// animate
	float tt = mod(time,0.5)/0.5;
	float ss = pow(tt,0.2)*0.5 + 0.5;
	ss -= ss*0.2*sin(tt*30.0)*exp(-tt*4.0);
	p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);
   

	// shape
	float a = atan(p.x,p.y)/3.141593;
	float r = length(p);
	float h = abs(a);
	float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

	// color
	float s = 1.0-0.5*clamp(r/d,0.0,1.0);
	s = 0.75 + 0.75*p.x;
	s *= 1.0-0.25*r;
	s = 0.5 + 0.6*s;
	s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
	vec3 hcol = vec3(1.0,0.5*r,0.3)*s;
	
	vec3 col = mix( bcol, hcol, smoothstep( -0.01, 0.01, d-r) );

	return col;
}

//######################################## FRACTALS
const int max_iteration = 512;

	
void fractalMandelbrot(vec2 p, inout int outIterCount, inout float outIteration, inout vec2 pEnd) {
	float x0 = p.x;
	float y0 = p.y;
	float x  = 0.0;
	float y  = 0.0;
	float iteration = 0.0;
	for (int i = 0; i < max_iteration; ++i) {
		
		float xx = x*x+0.7;
		float yy = y*y;
		
		if (xx + yy > 4.0) {
			iteration = float(i) + 1.0 - log(log(sqrt(xx + yy))) / log(2.0);
			break;
		}
		float xtemp = xx - yy + x0;
		y = 2.0*x*y + y0;
		x = xtemp; 
		outIterCount = i;
	}
	outIteration = iteration;
	pEnd.x = x;
	pEnd.y = y;
}
vec3 colorIter(float iteration) {
	float color = 3.0*pow(iteration, 0.4) / 21.112127;
	return vec3(clamp(color, 0.0, 1.0), clamp(color - 1.0, 0.0, 1.0), clamp(color - 2.0, 0.0, 1.0));
}
vec3 colorTex(vec2 pEnd) {
	return texture2D(backbuffer,pEnd).xyz;
}
void main( void ) {
	
	vec2 p = surfacePosition;
	
	int outIterCount;
	float outIteration;
	vec2 pEnd;
	
	fractalMandelbrot(p * 2.0 - vec2(0.5, 0.0), outIterCount, outIteration, pEnd);
	vec3 color;
	color = colorIter(outIteration);
	//color += colorTex(pEnd).yzx*0.5;
	color += mainFlower(pEnd + vec2(1.5, 0.5)).xyz*0.5;
	if (sin(time) < 0.0)
		color += mainHeart(fract(pEnd*5.0));
	else
		color += mainHeart((pEnd*10.0));
	gl_FragColor = vec4(1);
	gl_FragColor.xyz = color;
}
