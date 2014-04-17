#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	float b = (sin(time*3.14159*2.0*mouse.x*20.0)*mouse.y+1.0)*0.5;
	gl_FragColor = vec4(b,b,b, 0);
}