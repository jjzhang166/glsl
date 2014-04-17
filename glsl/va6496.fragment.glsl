#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	float aspect = resolution.x / resolution.y;
	position *= 50.0;
	position.x *= aspect;
	vec2 m = mouse * 2.0 - 1.0;
	m *= 50.0;
	m.x *= aspect;
	float color = 0.0;
	color += sin(length(position) - time * 2.0);
	color += sin(distance(m, position) - time * 2.0);
	gl_FragColor = vec4( vec3( color * 0.0 , color * 0.5, color * 1.0), 1.0 );

} 