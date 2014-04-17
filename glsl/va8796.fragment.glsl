#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// modified 2013-03-31, 2013-04-01 by @hintz
// roto-zoom 2013-04-02 by @hintz
// hyper-mod by @kapsy1312

// feature switches:
// #define hole 
#define spikes
#define acryl
#define fading

float t = time*1.1;

float circle(vec2 center, float radius, vec2 position)
{
	float length = distance(position, center);

#ifdef spikes
	radius*=1.0-0.1/(0.8+0.1/(0.9-abs(sin(t-7.5*atan(position.y-center.y, position.x-center.x)))));
#endif

#ifdef acryl
	return length < radius ? sin(pow(length / radius, 40.0) * 3.0 + 0.3) : 0.0;
#else
	return length < radius ? 1.0-(pow(length / radius, 4.0)) : 0.0;
#endif
}

#ifdef hole
float circle2(vec2 center, float radius, vec2 position)
{
	float length = distance(position, center);
	
	radius*=0.3+0.21/(1.0+abs(sin(2.5/4.5*time-2.5*atan(position.y-center.y, position.x-center.x))));
	
	return length < radius ? sin(pow(length / radius, 20.0) * 3.0 + 0.3) : 0.0;
}
#endif

float c = cos(0.01*sin(t*0.1));
float s = sin(0.01*sin(t*0.1));
vec2 rotate(vec2 p)
{
	return vec2(c*p.x-s*p.y, c*p.y+s*p.x);
}
	
void main(void)
{
	
	
	vec2 position = 2.0*(gl_FragCoord.xy - 0.5 * resolution) / resolution.y;
	
	float r = circle(vec2(sin(t*1.01), cos(t*0.98)), 1.0+sin(t*.9), position);
	float g = circle(vec2(cos(t*0.94), sin(t*0.97)), 1.0+sin(t*.8), position);
	float b = circle(vec2(sin(t*0.93), sin(t*0.99)), 1.0+sin(t*.7), position);
	float m = circle(vec2(-cos(t*1.02), -sin(t*0.96)), 1.0+sin(t*.6), position);
	float y = circle(vec2(-sin(t*0.92), -sin(t*1.03)), 1.0+sin(t*.5), position);
	float w = circle(vec2(-sin(t*1.05), cos(t*0.95)), 1.0+sin(t)*.4, position);
	float o = circle(vec2(cos(t*0.91), -cos(t*1.04)), 1.0+sin(t)*.3, position);
#ifdef hole
	r -= circle2(vec2(sin(t*1.01), cos(t*0.98)), 1.0+sin(t*.9), position);
	g -= circle2(vec2(cos(t*0.94), sin(t*0.97)), 1.0+sin(t*.8), position);
	b -= circle2(vec2(sin(t*0.93), sin(t*0.99)), 1.0+sin(t*.7), position);
	m -= circle2(vec2(-cos(t*1.02), -sin(t*0.96)), 1.0+sin(t*.6), position);
	y -= circle2(vec2(-sin(t*0.92), -sin(t*1.03)), 1.0+sin(t*.5), position);
	w -= circle2(vec2(-sin(t*1.05), cos(t*0.95)), 1.0+sin(t)*.4, position);
	o -= circle2(vec2(cos(t*0.91), -cos(t*1.04)), 1.0+sin(t)*.3, position);

	r = abs(r);
	g = abs(g);
	b = abs(b);
	m = abs(m);
	y = abs(y);
	w = abs(w);
	o = abs(o);
#endif	
	
#ifdef fading
	gl_FragColor = vec4(r+y+m+o+w, g+y+0.5*o+w, b+m+w, 1.0)*0.06+texture2D(backbuffer, 0.995*rotate(gl_FragCoord.xy-0.5*resolution)/resolution+0.5)*0.95;
#else
	gl_FragColor = vec4(r+y+m+o+w, g+y+0.5*o+w, b+m+w, 1.0);
#endif
}