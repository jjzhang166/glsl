#ifdef GL_ES
precision mediump float;
#endif

// forked from www.cake23.de/entertheloop2.html 
// by @Flexi23

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

vec2 torus_mirror(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}

float circle(vec2 uv, float scale){
	return clamp( 1. - length((uv-0.5)*scale), 0., 1.);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - 0.5)) - radius) * sharpness) * 0.5;
}

void main( void ) {
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + (gl_FragCoord.xy * vec2(1./resolution.x,1./resolution.y) - 0.5)*aspect;
	float mouseW = atan((mouse.y - 0.5)*aspect.y, (mouse.x - 0.5)*aspect.x);
	vec2 mousePolar = vec2(sin(mouseW), cos(mouseW));
	vec2 offset = (mouse - 0.5)*4.;

	vec2 uvr = uv;
	uvr = 0.5 + complex_mul((uvr-0.5)*aspect, mousePolar) - complex_mul((offset-0.5)*aspect, mousePolar);
	vec2 uvg = complex_div(vec2(0.16), uv - 0.5);
	uvg = mix( 0.5 + (uvr- 0.5)*4., uvg + 0.5, 0.5); 
	uvg = torus_mirror(uvg + time*0.005);
	
	gl_FragColor = 0.9*texture2D(backbuffer, uvg) + circle(uv, 4.)*0.35;
	
}