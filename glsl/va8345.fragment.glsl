#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	
	int i;
	int softCircle = 1; // edit this to switch between soft and hard circle
	
	vec2 position =gl_FragCoord.xy;
	vec2 mid = resolution / 20.0;
	mid = mouse * resolution;
	float distanceToMid = length(position-mid); 
	float color;
	
	if (softCircle == 1) {
		color = (0.7-sin(distanceToMid/10.0-sin(time*5.0)-time*2.0 ))/distanceToMid*50.0+sin(position.x)/10.0+cos(position.y)/10.0;
	} else {
		if (distanceToMid < resolution.y/4.0){
			color = 1.0;
		} else {
			color = 1.0;
		}
	}
	
	gl_FragColor = vec4( color, color , color, 0.01 );
}