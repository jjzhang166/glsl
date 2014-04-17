#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec4 color = vec4(0.2, 1.0, 0.2, 1.0);

	vec2 st = ( gl_FragCoord.xy / resolution.xy );
	st.s *= resolution.x / resolution.y;
	st -= vec2(mouse.x * resolution.x / resolution.y, mouse.y);
	st *= 10.0;

	float len = length(st);
	float circle = 1.0 - smoothstep(0.75, 0.79, len) * (1.0 - smoothstep(0.81, 0.85, len));
	float vertLine = 1.0 - (1.0 - smoothstep(0.01, 0.04, abs(st.s))) * (1.0 - smoothstep(0.96, 1.0, abs(st.t)));
	float horizLine = 1.0 - (1.0 - smoothstep(0.01, 0.04, abs(st.t))) * (1.0 - smoothstep(0.96, 1.0, abs(st.s)));
	float val = 1.0 - circle * horizLine * vertLine;

	gl_FragColor = color * val;

}