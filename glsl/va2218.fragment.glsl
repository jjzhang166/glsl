#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159;

float d(float x, float y){return 2.0*x*x+y*y;}

void main(void) {

	vec2 position = (gl_FragCoord.xy/resolution.xy)-0.3;

	float color = 0.0;
	float x = position.x - 0.8;
	float y = position.y - 0.6;
	
	x -= sin(time)/10000.6;
	y += cos(time)/8000.0;
	
	color += sin(1.5*pi*d(x,y)*sqrt(d(x,y))*(6000.0+time));
	gl_FragColor = vec4(
		color*sin(time*0.4)*9.0,
		color*cos(time*0.02)*mouse.x, 
		color*cos(time*0.1)*sin(time*0.3)*x*mouse.y, 
		1.0);
}