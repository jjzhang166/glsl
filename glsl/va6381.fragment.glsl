#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;
const vec2 wind = vec2(0.06,0.04314);
const float cloudSize = 0.714;
const float fogginess = 0.35; //smaller is bigger
const float softness  = 0.9; 


float hash( float n ) {
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x ) {
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+58.0),f.x),f.y);
    	return res;
}


void main( void ) {
	vec2 p = surfacePosition * cloudSize + 0.5 + time * wind;
	float c0 = noise(p*1.551 + time *.15);
	float c1 = noise(p*2.013 - time *.28917);
	float c2 = noise(p*1.131 - time *.02417);
	float c3 = noise(p*1.4131 - time *.012415);
	
	float cf = smoothstep(fogginess*c3, fogginess+softness, c0*c1*c2);
	
	vec3 c = vec3(cf);
	gl_FragColor = vec4(c, 1.);
}