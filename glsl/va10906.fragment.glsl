#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) 
{
	if(gl_FragCoord.x < 1.0*time)
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	else
		gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
}