#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
//uniform vec2 resolution;

void main( void ) 
{

	gl_FragColor = vec4(1.,0,0,1.) * ceil(sin(time * mouse.x * 77.));
}