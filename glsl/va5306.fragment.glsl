#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float max_distance = 300.0/((resolution.x+resolution.y)/2.0);
	float dx = (mouse.x - gl_FragCoord.x/resolution.x);
	float dy = (mouse.y - gl_FragCoord.y/resolution.y);
	float pixDist = sqrt(pow(dx,2.0)+pow(dy,2.0)); 
	
	float color = 1.0-cos(2.0*3.14)*pixDist*5.0;
	float highlight = sin((time-pixDist)*10.0)*(1.0-min(pixDist/max_distance,1.0));
	
	gl_FragColor = vec4(color,highlight,color,1.0);

}