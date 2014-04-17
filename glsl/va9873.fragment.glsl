#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec4 c = vec4(0, 1, 1, 0);
	vec4 m = vec4(0.9, 0, 0.45, 0);
	vec4 y = vec4(1, 1, 0, 0);
	
	float steps = mod(time, 3.0);
	
	vec4 a;
	vec4 b;	
	
	if (steps > 2.0) {
		a = m;
		b = c;
	} else if (steps > 1.0) {
		a = y;
		b = m;
	} else {
		a = c;
		b = y;
	}
	
	gl_FragColor = mix(a, b, mod(time, 1.0));
}