// math shape test
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float r,g,b,a;
	float xCenter ,yCenter;
	vec2 position = -1.0+2.0*gl_FragCoord.xy/resolution.xy ;
	xCenter = resolution.x / 2.0,yCenter = resolution.y / 2.0;
	
	float color = 0.0;
	float x1,y1;
	//x1=(position.x -200.0)* (1.0+sin(time));
	//y1=position.y ;
	
	x1=position.x;y1=position.y;
	
	float d = sqrt(pow((x1),2.0)+pow((y1),2.0));
	float the= atan(y1/x1);
	float d2 = .70*sin(9.0*the);
	
	if(abs(d-d2) < 0.00150)
	{
		r =0.0*sin(time);
		g =1.0;
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