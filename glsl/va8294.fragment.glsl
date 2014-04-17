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
	vec2 mid = resolution / 2.0;
	mid = mouse * resolution;
	float distanceToMid = length(position-mid); 
	float color;
	
	if (softCircle == 1) {
		color = 1.0-distanceToMid/(resolution.y/3.0);
	} else {
		if (distanceToMid < resolution.y/4.0){
			color = 1.0;
		} else {
			color = 0.0;
		}
	}
	
	gl_FragColor = vec4( color, color , color, 1.0 );
}