#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265359

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy * 2.0 - vec2(1.0);
	position.x *= resolution.x / resolution.y;
	
	float r = length(position);
	float a = atan(position.y, position.x);
	
	if (mod(r, 0.3) > 0.2 && mod(a - time, PI / 3.0) < 0.5) {
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}	else {
		gl_FragColor = vec4(float(mod(a + r + time, PI / 1.5) < 0.3));
	}
}