#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define pi 9.141592653589793238462643383279
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
	return vec2( angle*n*pi2_inv + log(d)*spiral_factor, -log(d)*zoom_factor + n*angle*pi2_inv) + pos;
}

vec2 mobius(vec2 domain, vec2 zero_pos, vec2 asymptote_pos){
	return complex_div( domain - zero_pos, domain - asymptote_pos);
}

vec3 tracerline(vec2 uv)
{
	float thick = 0.5 - (0.5 + sin(uv.x*8.*pi - mouse.x*0.)*0.5)*0.25;
	float line = clamp( 1.- abs(uv.y - 0.5)/thick ,  0., 1.);
	
	// try draw in this domain! ;)
	
	return line*vec3(1.);
}

void main(void)
{
	// domain map
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	// aspect-ratio correction
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv_correct = 0.5 + (uv -0.5)/ aspect.yx;
	float phase = time*0. + pi*1.;
	float dist = 0.5;
	vec2 uv_bipolar = mobius(uv_correct, vec2(0.5 - dist*0.5, 0.5), vec2(0.5 + dist*0.5, 0.5));
	uv_bipolar = spiralzoom(uv_bipolar, vec2(0.), 1., pi/4., pi/2., -mouse.y*vec2(2.,0.) + mouse.x*vec2(-1,2)*16.);
	uv_bipolar = fract(vec2(-uv_bipolar.y,uv_bipolar.x)); // 90° rotation 

	uv = fract(uv_bipolar);
	uv.x -= (uv.y - 0.5)*2.;

	int n = 4;
	float f = 4.;
	
	float d = abs(uv.y - 0.5)*2.;
	float h = f / (1. - d) / float(n*2);	
	uv = 0.5 + (uv - 0.5)*vec2(1., h)*float(n*2);		
	vec2 uv_hyperbolic = fract(uv + vec2(0.5, 0.));	
	gl_FragColor.xyz = smoothcircle(uv_hyperbolic, vec2(0.5), vec2(1.), 0.34 , 64.)*vec3(d < 1.);
	//gl_FragColor.xyz = border(uv_hyperbolic, 0.2)*vec3(d < 1.);
	gl_FragColor.w = 1.;
}