#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265

uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

float f(float x) {
	return (sin(x * 2.0 * PI ) + 1.0) / 2.0;
}

float q(vec2 p) {
	float s = (f(p.x + 0.25)) / 5.0; 
	
	float c = smoothstep(0.9, 1.0, 1.0 - abs(p.y - s));  
	return c; 
}

vec3 aurora(vec2 p, float time) {
	vec3 c1 = q( vec2(p.x, p.y / 0.4) + vec2(0.1, -0.3)) * vec3(4.0, 1.0, 1.0); 	
	vec3 c2 = q( vec2(p.x, p.y) + vec2(time, -0.2)) * vec3(.1, .1, 1.0); 	
	vec3 c3 = q( vec2(p.x, p.y / 0.4) + vec2(time / 2.0, -0.5)) * vec3(.10, 1.0, .10); 
	
	return c1+c2+c3; 
}

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy );		
	vec3 c = aurora(p, time); 
	gl_FragColor = vec4(c, 1.0); 	
}