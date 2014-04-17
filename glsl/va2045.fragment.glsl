#ifdef GL_ES
precision mediump float;
#endif

// If you're going to do a strobe, do it right.

// Fixed it to make it right.

uniform sampler2D backbuffer;
uniform float time;
uniform vec2 resolution;

void main( void ) {
	gl_FragColor = 1.0 - texture2D(backbuffer, gl_FragCoord.xy / resolution);

}