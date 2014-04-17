#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{

	gl_FragColor = vec4( 0.3, 0.5, 0.7, 1.0 );

}