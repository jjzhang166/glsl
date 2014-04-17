#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	float proximity = distance(gl_FragCoord.xy, mouse*resolution.xy);
		
		
		

	gl_FragColor = vec4( vec3(1.-proximity*.01), 1.0 );

}