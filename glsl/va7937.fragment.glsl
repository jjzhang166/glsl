#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	p-=.5;
	
	vec4 col;
	
	float x=p.x;
	float y=p.y;
	
	float r = sqrt( x*x + y*y );
	

	col.r=r;
	
	
	col.g = 0.0;
	col.b = 0.0;
	
	
	col.a = 1.0;
	gl_FragColor = col;
}
