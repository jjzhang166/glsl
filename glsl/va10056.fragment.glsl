#ifdef GL_ES
precision highp float;
#endif

// valurele :)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float col = (sin(time * 3.0 - length((gl_FragCoord.xy - mouse * resolution) / 20.0)) + 1.0) / 2.0;
	col -= (sin(time * 3.0 - length((gl_FragCoord.xy - mouse * resolution + vec2(20.0, -20.0)) / 20.0)) + 1.0) / 2.75;
	gl_FragColor = vec4(col);
}