// surfacePosition vs. vec2 position = ( gl_FragCoord.xy / resolution.xy)
// 0.0 , 0.0 is the center now
// but the limits are no clear....
// [-0.7 to 0.7] for the X-axis? and [-0.5 to 0.5] for the y-axis?

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {

	vec2 p= surfacePosition;
	
	//uncomment to use the other traditional way (fastest?!¿!)	
	//vec2 p = ( gl_FragCoord.xy / resolution.xy);
	//p.y=p.y-0.5;
	//p.x=p.x-0.7;
	
	float c = 0.0;
	float d=0.0;
	

	c=p.x;
	d=p.y;
	if(p.y>-0.5+mouse.y)
		c=0.0;
	else 
		c=1.0;
	if(p.x>-0.7+mouse.x)
		d=0.0;
	else 
		d=1.0;
	gl_FragColor = vec4(c,0.0,d,1.0);
}