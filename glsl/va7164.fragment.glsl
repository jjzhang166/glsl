#ifdef GL_ES
precision mediump float;
#endif
// tribal tattoo by Snoep Games

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 3.14159
#define TWO_PI (PI*2.0)



void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy) * 15.0 ;
	position.x+=60.0;
	position.y+=60.0;
	float timezoom=time/1.0;
	float n=5.0;
	float color = 0.0;
	float a=0.0;
	float b=0.0;
	float torad=(25.0+sin(timezoom))/20000.0*2200.0;
	float zoom=800.0/(resolution.x*resolution.y);
	
	for(float i = 0.0; i < 7.0 ; i+=1.0) 
	{	
		float pos_x=(position.x+5000.0*sin((timezoom)/20.0+i*17.0))*zoom;
		float pos_y=(position.y+5000.0*cos((timezoom)/20.0+i*17.0))*zoom;
		a=sin(pos_x)*cos(atan(pos_y,pos_x));
		b=sin(pos_y)*cos(atan(pos_x,pos_y));
		color+= 100.0*sin(atan(a*a-b,b*b-a));
	}
	color=color*color;
	if(color<1200.0) color=0.0;
	else color=1.0;
	gl_FragColor = vec4( vec3( color,color,color), 1.0 );

}