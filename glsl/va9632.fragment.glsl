#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265

void main( void ) {

	vec4 color = vec4(1.0, 1.0, 0.0, 1.0);

	vec2 st = ( gl_FragCoord.xy / resolution.xy );
	st.s *= resolution.x / resolution.y;
	st -= vec2(mouse.x * resolution.x / resolution.y, mouse.y);
	st *= 20.0;

	float len = length(st + vec2(0.0, -2.0));
	float circle = smoothstep(0.80, 0.85, len);
	float curve = (1.0 - cos(st.t * PI * 0.5)) * 0.5 * 0.80;
	float lower = 1.0 - (1.0 - smoothstep(curve, curve + 0.05, abs(st.s))) * (1.0 - smoothstep(0.95, 1.0, abs(st.t - 1.0)));
	float inscription = smoothstep(0.30, 0.35, len);
	float val = (1.0 - circle * lower) * inscription;

	gl_FragColor = color * val;

}