#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float r,g,b,a;
	float xCenter ,yCenter;
	vec2 position = gl_FragCoord.xy ;
	xCenter = resolution.x / 2.0,yCenter = resolution.y / 2.0;
	
	float color = 0.0;
	float x1,y1;
	x1=(position.x -200.0)* (1.0+sin(time));
	y1=position.y ;
	
	float d = sqrt(pow((x1-xCenter),2.0)+pow((y1-yCenter),2.0));
	
	if(d < 100.0)
	{
		r =1.0*sin(time);
		g =1.0+cos(d+11.0);
		b =0.0*tan(1.9);
		a=1.0;
	}
	else
	{
		r = 0.0;
		g = 0.0;
		g = 0.0;
		a = 1.0;
		
	}
		
	
	
	
	gl_FragColor=vec4(r,g,b,a);

}