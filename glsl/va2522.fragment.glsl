#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159;

float d(float x, float y){return x*x+y*y;}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;+ mouse / 4.0 - 0.15;
	float moused = d(mouse.x-0.5, mouse.y-0.5);
	float color = 0.0;
	float dist = 2000.0;
	float x = position.x - 0.1;
	float y = position.y - 0.1;
	dist *= 0.02/(moused);
	dist *= 0.02/(mouse.y - 0.5);
	x += sin(time)/time;
	y += cos(time)/time;
	
	color += sin(pi*pow(d(x,y),1.5)*2000.0);
	color = color/2. + 0.5;
	gl_FragColor = vec4( color*sin(time*pi) , color*0.2 , color*cos(time*pi) , 1.0 );
}