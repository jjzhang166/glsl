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
	
	//c=0.90 - abs(0.8  - .2 * sin(p.x * 13.0 - time / .5 - cos(time / 0.4)) - p.x + (p.x * sin(time) / 13.) * sin(time + ((p.x / .5))) / .15);
	
	c = 1.1 - abs(.6  - .1 * sin(p.x * 32.0) - p.x + (p.x  * cos(time) / 1.) * cos(time));
	
	//c=pow(c, 10.1 / p.y)*(10.10-p.y);
		
	gl_FragColor = vec4(c*p.x, c*p.y, c * sin(time),1.0);
}