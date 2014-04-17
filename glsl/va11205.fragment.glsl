#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pos = gl_FragCoord.y / resolution.y;
	float a1 = 1.0 - ((pos - 0.3) / 0.7);
	float a2 = (pos / 0.3);
	float a = min(a1, a2);
	gl_FragColor = vec4(a * 1.0, a * 1.0, a * 1.0, 1.0);

}