#ifdef GL_ES
precision mediump float;
#endif

// Hi, I'm 5 years old and I have no idea what I'm doing.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec2 surfacePosition;

void main( void ) {

	if (distance(gl_FragCoord.xy, surfacePosition) < 100.0) {
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	}

}