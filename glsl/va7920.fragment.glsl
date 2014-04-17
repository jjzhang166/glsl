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
	
	float x1,x2,x;
	float y1,y2,y;
	x1=x2=x=p.x;
	y1=y2=y=p.y;
	
	x1-=cos(time)*.25;
	y2-=sin(time)*.25;

	x-=cos(time)*.25;
	y-=sin(time)*.25;

	
	float r1 = sqrt( x1*x1 + y1*y1 );
	float r2 = sqrt( x2*x2 + y2*y2 );
	float r = sqrt( x*x + y*y );
	
	//float theta = atan(y/x);
	
	if(-r1*16.0+1.0>0.0)
		col.r=1.0;
	if(-r2*16.0+1.0>0.0)
		col.g=1.0;
	if(-r*16.0+1.0>0.0 || abs(x)<.001 || abs(y)<.002)
		col.b=1.0;
	
	//col.b = 0.0;
	
	
	col.a = 1.0;
	gl_FragColor = col;

}
