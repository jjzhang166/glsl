#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void foo(int x)
{
	return sin(x)*cos(x)-0.5*tan(x);
}
	
void main( void )
{
	
	
	gl_FragColor = vec4( foo(mouse.x)/100.0, foo(mouse.y)/1000, 0.0, 1.0 );
}