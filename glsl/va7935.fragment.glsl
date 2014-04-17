#ifdef GL_ES
precision mediump float;
#endif

// A sun looking thing
// by zach@cs.utexas

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	float radius = length(gl_FragCoord.xy - resolution*0.5);
	
	gl_FragColor = vec4(48.0/radius, 20.0/radius, 10.0/radius, 1.0);
}