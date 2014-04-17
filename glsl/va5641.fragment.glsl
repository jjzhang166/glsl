#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float round(float v)
{
	if(v - floor(v) >= 0.5) return floor(v)+1.0;
	else return floor(v);

}

vec2 round(vec2 v)
{
	vec2 ret = vec2(0.0);
	if(v.x - floor(v.x) >= 0.5) ret.x = floor(v.x)+1.0;
	else ret.x = floor(v.x);
	if(v.y - floor(v.y) >= 0.5) ret.y = floor(v.y)+1.0;
	else ret.y = floor(v.y);
	return ret;
}

float triwave(float x)
{
	return 1.0-4.0*abs(0.5-fract(0.5*x + 0.25));
}

//from #3611.0

float rand(vec2 co){
	float t = mod(time,16.0);
    return fract(sin(dot(co.xy ,vec2(1.9898,7.233))) * t*t);
}

//from http://github.prideout.net/barrel-distortion/

float BarrelPower = 1.085;
vec2 Distort(vec2 p)
{
    float theta  = atan(p.y, p.x);
    float radius = length(p);
    radius = pow(radius, BarrelPower);
    p.x = radius * cos(theta);
    p.y = radius * sin(theta);
    return 6.5 * (p + 1.0);
}

vec3 shader( vec2 p, vec2 resolution ) {

	vec2 pos = ( p / resolution.xy );

	vec3 color = vec3(0.0);
	
	float wave = 1.-abs(pos.y - (sin((cos(pos.x + cos(time) +(3.*sin(time /2.))))*PI*4.+cos(time))*0.25+1.)); // 'just string together a bunch of random stuff' remix
	
	color = vec3(0.,pow(wave,16.),0.);
	color += vec3(pow(wave,32.));
	
	return vec3(color);

}

float xxx = 8.0;

float pixelsize = 18.0 * xxx;


vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}


vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 torus_mirror(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - 0.5)) - radius) * sharpness) * 0.5;
}


void main() {

	vec2 posScale = vec2(2.0);
	
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + (gl_FragCoord.xy * vec2(1./resolution.x,1./resolution.y) - 0.5)*aspect*resolution;
	float mouseW = atan((mouse.y - 0.5)*aspect.y, (mouse.x - 0.5)*aspect.x);
	vec2 mousePolar = vec2(sin(mouseW), cos(mouseW));
	vec2 offset = (mouse - 0.5)*2.*aspect*12800.;
	offset =  - complex_mul(offset, mousePolar) +time*0.0;
	vec2 uv_distorted = uv;
	
	float filter = smoothcircle( uv, 0.1, 32.);
	uv_distorted = complex_mul(((uv_distorted - 0.5)*mix(1., 1., filter)), mousePolar) + offset;


   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y*resolution.x);

	vec2 position = ( gl_FragCoord.xy + resolution*1.5)/4.;
	
	position = mix(position, position, 1.-filter);
	
	vec3 color = vec3(1.0);
	
	vec2 dposition = Distort(position/resolution-0.5)*(resolution*100.0);
	
	vec2 rposition = round(((dposition-(pixelsize/2.0))/pixelsize));
	
	
	color = vec3(shader(rposition,resolution/pixelsize));
	
	color = clamp(color,0.0625,1.0);
	
	color *= (rand(rposition)*10.25+0.75);
	
	color *= abs(sin(rposition.y*8.0+(time*16.0))*0.15+0.85);
	
	color *= vec3(clamp( abs(triwave(dposition.x/pixelsize))*3.0 , 0.0 , 1.0 ));
	color *= vec3(clamp( abs(triwave(dposition.y/pixelsize))*3.0 , 0.0 , 1.0 ));
	
	float darkness = sin((position.x/resolution.x)*PI)*sin((position.y/resolution.y)*PI);
	
	color *= vec3(clamp( darkness*4.0 ,0.0 ,1.0 ));
	
	gl_FragColor = vec4( color, 1.0 );

}