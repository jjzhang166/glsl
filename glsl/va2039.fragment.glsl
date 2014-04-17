#ifdef GL_ES
precision mediump float;
#endif

// If you're going to do a strobe, do it right.
uniform sampler2D backbuffer;
uniform float time;

void main( void ) {

	vec2 position = gl_FragCoord.xy;

	if(time<0.1){
		gl_FragColor = vec4(0.);
		return;
	}

	gl_FragColor = 1. - texture2D(backbuffer, position);

}