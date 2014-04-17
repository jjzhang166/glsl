#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{
	gl_FragColor += vec4(sin(0.05*gl_FragCoord.x - 50.0*mouse.x + 2.0*sin(10.0*time + 50.0))*cos(time), 
			     cos(0.05*gl_FragCoord.y - 50.0*mouse.y + 5.0*cos(5.0*time + 10.0))*cos(time + 1.0), 
			     sin(0.05*gl_FragCoord.x - 50.0*mouse.x + 2.0*sin(10.0*time))*cos(2.0*time) * cos(0.05*gl_FragCoord.y - 50.0*mouse.y)*cos(2.0*time + 1.0) * 5.0, 
			     1.0);
}