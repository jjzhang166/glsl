#ifdef GL_ES
precision mediump float;
#endif

// forked from www.cake23.de/entertheloop4.html 
// by @Flexi23

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
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

	gl_FragColor = vec4(circle(uv, 5.)* 0.5); // seed

	float filter = smoothcircle(uv, 0.12, 24.);
	gl_FragColor += texture2D(backbuffer, torus_mirror(0.5 + complex_mul(((uv - 0.5)*mix(2., 16., filter)), mousePolar) - complex_mul(offset, mousePolar) +time*0.02))*mix(1., 0.6, filter); // add complex feedback (:
}