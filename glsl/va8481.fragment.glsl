#define PROCESSING_COLOR_SHADER

// bars - thygate@gmail.com

// rotation and color mix modifications by malc (mlashley@gmail.com)
// modified by @hintz 2013-05-04

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//uniform float sound;

vec2 position;
vec4 color;

float c = cos(time/2.0);
float s = sin(time/2.0);
mat2 R = mat2(c,-s,s,c);

float barsize = 0.15 /**sound*/;
float barsangle = 200.0*sin(time*0.001);

vec4 mixcol(float value, float r, float g, float b)
{
	return vec4(value * r, value * g, value * b, value);
}

void bar(float pos, float r, float g, float b)
{
	color += sin(4.0*max(0.0, (1.0 - abs(pos - position.y * position.x) / barsize)) * vec4(r, g, b, 1.0));
}

void main(void) 
{
	position = (gl_FragCoord.xy / resolution.xy);
	position = position * 2.0 - 1.0;
	position = position * R; 		
		
	color = vec4(0.0);
	float t = time*0.5;

	bar(sin(t), 1.0, 0.0, 0.0);
	bar(sin(t+barsangle/6.*2.), 1.0, 0.5, 0.0);
	bar(sin(t+barsangle/6.*4.), 1.0, 1.0, 0.0);
	bar(sin(t+barsangle/6.*6.), 0.0, 1.0, 0.0);
	bar(sin(t+barsangle/6.*8.), 0.0, 1.0, 1.0);
	bar(sin(t+barsangle/6.*10.), 0.0, 0.0, 1.0);
	bar(sin(t+barsangle/6.*12.), 0.5, 0.0, 1.0);
	bar(sin(t+barsangle/6.*14.), 1.0, 0.0, 1.0);

	gl_FragColor = color;
	gl_FragColor.a = 1.0;
}