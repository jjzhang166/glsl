#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.xy;
	int subdiv = 32;
	float phase = pos.y * 2.0 * 3.14159 * float(subdiv);
	float value = sin( phase + time ) * 0.5 + 0.5;

	gl_FragColor = vec4(value, value, value,1.0);
}