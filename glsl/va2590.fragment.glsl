#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );

	float color = 0.3;
	float proximity = distance(gl_FragCoord.xy, mouse*resolution.xy)*mod(position.x*position.y,mouse.x*mouse.y);
		
		
		

	gl_FragColor = vec4( vec3(1.-proximity*.01), 1.0 );

}