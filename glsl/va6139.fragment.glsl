#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.1416;
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.x )* 2.0 - vec2(1,resolution.y/resolution.x);
	
	float alfa = time;
	vec2 temp = p;
	//p.x = (temp.x * cos(alfa)) - (temp.y * sin(alfa));
	//p.y = (temp.x * sin(alfa)) + (temp.y * cos(alfa));
	
	float r = 0.0;
	float point_size = 32.0;
	
	r += sqrt(p.x * p.x + p.y * p.y);

	gl_FragColor = vec4( r, 0.0, 0.0, 1.0 );

}