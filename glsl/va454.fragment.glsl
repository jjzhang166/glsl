#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int nrOfPoints = 3;
float points[nrOfPoints];

void main( void ) {
	//for(int i = 0; i < nrOfPoints; i++){
	//	points[i] = 3.0;
	//}
	

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse;

	float c = float(gl_FragCoord.y < (resolution.y/2.0 + sin(gl_FragCoord.x/20.0)*position.x*20.0));
	

	gl_FragColor = vec4( vec3( c, c, c ), 1.0 );
}