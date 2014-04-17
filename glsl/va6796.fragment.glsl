#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Damian Balandowski (c) 2013

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );


	float dist = distance(position, vec2(0.5, 0.5));
	float qdist = dist * dist * sqrt(dist);
	float diff = 0.00 * dist + qdist * -200.0;

	float color = 0.0;
	color += (1.0 / dist + diff) * 0.1;
	color += sin(dist * time)*cos(time * 5.0) * 0.8;
	

	


	
	

	gl_FragColor = vec4(color * 0.2, color * 0.7, color, 1.0);

}