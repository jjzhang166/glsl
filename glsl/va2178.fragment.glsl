#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159;

float d(float x, float y){return x*x+y*y;}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;+ mouse / 9.0 - 0.15;

	float color = 0.0;
	float x = position.x - 0.8;
	float y = position.y - 0.6;
	
	x += sin(time)/2000.6;
	y += cos(time)/2000.0;
	
	color += sin(pi*d(x,y)*sqrt(d(x,y))*2000.0);
	//color = color/2. + 0.5;
	gl_FragColor = vec4( color*0.2 , color*0.5 , color , 1.0 );
}