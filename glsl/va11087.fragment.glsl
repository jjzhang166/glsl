#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

const float Pi = 3.14159;
const int zoom = 40;
const float speed = 1.0;
float fScale = 1.25;

void main(void)
{	
	gl_FragColor = vec4(time, time, time/2.0, 1.0);
}