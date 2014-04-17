#ifdef GL_ES
precision mediump float;
#endif

#define AUDIO_RATIO 25.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec3 normal; 

void main( void ) {

	if( mod( abs(gl_FragCoord.x) ,4.0) == 0.0 )
	{
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); 
	}
	else
	{
		gl_FragColor = vec4(0.0, 1.0, 1.0, 1.0); 
	}
	
	
}