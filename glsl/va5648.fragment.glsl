#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec3 meshColor;

void main( void ) 
{
	
	gl_FragColor = vec4(meshColor,1.0);	

}