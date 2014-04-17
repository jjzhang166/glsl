//The Hong Kong University of Science & Technology
//Marco Ma Hello Color World Example

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;

void main( void ) 
{
	gl_FragColor = vec4(gl_FragCoord.x*0.0015,mouse.x,mouse.y,1);
}