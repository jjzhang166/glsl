#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 normalisedAndCentered;
	if(resolution.y/resolution.x<1.)
	//if(true)
		normalisedAndCentered = ( gl_FragCoord.xy / resolution.yy)*2. - vec2(resolution.x/resolution.y,1);	//Height Driven
	else 	
		normalisedAndCentered = ( gl_FragCoord.xy / resolution.xx)*2. - vec2(1,resolution.y/resolution.x);	//Width Driven
	
	
	vec3 color = vec3(0,0,0);
	color.rg = abs(normalisedAndCentered/10.);
	
	//central circle
	float r = length(normalisedAndCentered);
	if(r<=.1)color.b = 1.0;
	
	//offset circles
	if(length(normalisedAndCentered-vec2(.5,.5))<=.05)color.r = 1.0;	
	if(length(normalisedAndCentered-vec2(-.5,.5))<=.05)color.g = 1.0;
	if(length(normalisedAndCentered-vec2(-.5,-.5))<=.05)color.r = 1.0;
	if(length(normalisedAndCentered-vec2(.5,-.5))<=.05)color.g = 1.0;
	
		//offset circles
	if(length(normalisedAndCentered-vec2(1.,1.))<=.025)color.r = 1.0;	
	if(length(normalisedAndCentered-vec2(-1.,1.))<=.025)color.g = 1.0;
	if(length(normalisedAndCentered-vec2(-1.,-1.))<=.025)color.r = 1.0;
	if(length(normalisedAndCentered-vec2(1.,-1.))<=.025)color.g = 1.0;
	
	
	gl_FragColor = vec4(color, 1);
}