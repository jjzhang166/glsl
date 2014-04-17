//By retrotails
//WIP, I save often to show friends
//Stare in the center, then around the room!
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec3 color = vec3(0.0, 0.0, 0.0);
	float tmp = 0.0;
	float scale = resolution.x/512.0;
	if (sqrt(pow(gl_FragCoord.x - resolution.x/2.0, 2.0) + pow(gl_FragCoord.y - resolution.y/2.0, 2.0)) > 2.0*scale) {
		tmp = sin(sqrt(pow(gl_FragCoord.x - resolution.x/2.0, 2.0) + pow(gl_FragCoord.y - resolution.y/2.0, 2.0))/scale - time * 32.0)
			- sqrt(pow(gl_FragCoord.x - resolution.x/2.0, 2.0) + pow(gl_FragCoord.y - resolution.y/2.0, 2.0))/resolution.y;
		color = vec3(tmp, tmp, tmp);
	} else {
		color = vec3(0.0, 1.0, 1.0);
	}	
	gl_FragColor = vec4(color, 1.0 );

}