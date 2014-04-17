#ifdef GL_ES
precision mediump float;
#endif

//kalu was here!

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 p = (gl_FragCoord.xy/resolution.y );
	

	float c=0.0;
	
	//c=.9;
	
	c=0.90 - abs(0.8  - .2 * sin(p.x * 1000.0 - time / .5 - cos(time / 0.4)) - p.x + (p.x * sin(time) / 13.) * sin(time + ((p.x / .5))) / 2.15);
	
	//c = 1.1 - abs(.6  - .1 * sin(p.x * 5000.0) - p.x + (p.x  * sin(time) / 1.) * cos(time));
	
	//c=pow(c, 10.1 / p.y)*(10.10-p.y);
		
	gl_FragColor = vec4(c*p.x-mouse.x, c*p.y-mouse.y/500., c * cos(time),1.0);
}