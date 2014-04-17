#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float bord1 = resolution.y*8.1/15., bord2 = resolution.y*7.9/13., bord3 = resolution.y*8./15., bord4 = resolution.y*8./13., a = mod(time,20.)*20.;
void circle(float a,float b, float c)
{
	if (pow(gl_FragCoord.x - resolution.x/a, 2.) + pow(gl_FragCoord.y - resolution.y/mod(time,10.)*b,2.) < c)
		gl_FragColor = vec4( 1,1,1,0.2);
}
void snowflake(	float aa,float b, float c)
{	 
	if (
	    abs(gl_FragCoord.x - gl_FragCoord.y-a*aa-b+120.) < 1.  && gl_FragCoord.x > bord1-c+b && gl_FragCoord.x < bord2+b+c
	    || abs(gl_FragCoord.y +a*aa -315.) <0.6 && gl_FragCoord.x > bord3+b-c && gl_FragCoord.x < bord4+b+c
	    || abs(gl_FragCoord.x -195.-b) <0.6 && gl_FragCoord.y > bord3 -a*aa+120.-c && gl_FragCoord.y < bord4-a*aa+120.+c
	    || abs(gl_FragCoord.x-510.+gl_FragCoord.y+a*aa-b)<0.5  && gl_FragCoord.x > bord1+b-c && gl_FragCoord.x < bord2+b+c	   
	   ) 
	
		gl_FragColor = vec4( 1,1,1,1);
}
void main( void ) {
	gl_FragColor = vec4( 0,0,mouse.x/mouse.y,1);
	circle(1.03,1.1,300.);
	circle(1.2,1.5,294.);	
	circle(1.8,0.5,330.);
	circle(2.3,1.,210.);	
	circle(5.8,0.7,150.);
	circle(11.8,1.3,270.);
	
	snowflake(1.,-180.,17.0);
	snowflake(1.3,-50.,2.);
	snowflake(1.5,-55.,-5.);
	snowflake(1.8,0.,10.);
	snowflake(1.7,40.,-8.);
	snowflake(0.7,120.,6.);
	snowflake(0.9,180.,0.);
	snowflake(1.1,182.,-4.);
	snowflake(1.4,282.,1.);
	snowflake(1.6,300.,-7.);
	snowflake(2.1,330.,12.);
	snowflake(1.9,430.,14.);	
	snowflake(1.9,440.,3.);		
}