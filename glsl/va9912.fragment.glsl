#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec4 c = vec4(0, 1, 1, 0);
	vec4 m = vec4(0.2, 0.4, 0.7, 0);
	vec4 y = vec4(1, 1, 0, 0);
	
	float steps = mod(time, 3.0);
	
	vec4 a;
	vec4 b;	
	
	if (steps > 2.0) {
		a = m;
		b = m;
	} else if (steps > 1.0) {
		a = m;
		b = m;
	} else {
		a = m;
		b = m;
	}
	
	gl_FragColor = mix(a, b, m);
}