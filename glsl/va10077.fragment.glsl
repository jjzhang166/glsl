#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	if (time < 0.5 || mouse.x < 0.01) {
		gl_FragColor = vec4(0.5);
		return;
	}
	vec2 p = gl_FragCoord.xy / resolution;
	vec4 bb = texture2D(backbuffer, p);
	if (distance(gl_FragCoord.xy, mouse*resolution) < 10.0) {
		gl_FragColor = vec4(1.0);
		return;
	}
	bb.a -= 0.01;
	if (bb.a < 0.01) {
		gl_FragColor = vec4(1.0-bb.rgb, 1.0);
		return;
	}
	gl_FragColor = bb;
}