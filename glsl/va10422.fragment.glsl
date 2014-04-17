#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co) {
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}                       

void main() {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float n = 20.0;
	float phase = time;
	float fs = 150.0;
	float contr = 1.0;
	float r = 2.0;
	float x = position.x-0.5;
	float y = -position.y+0.5;
	float R2 = r*r;
	float m = exp(-0.5*(x*x + y*y/R2)/pow(0.07,2.0));
	float c = m*contr*cos(fs*x - phase);
	c += (n*(rand(vec2(x,y)+phase)-0.5) + 0.5)/127.5;
	c = (1.0+c)/2.0;
	gl_FragColor.rgba = vec4(c + rand(vec2(x,y)),c + rand(vec2(y,x)),c + rand(vec2(x + y,sin(phase/6000.))),1.0);
}