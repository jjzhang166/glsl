#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 position = vec3(( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0,5);
	position.x -= 0.5;
	position.y -= 0.5;

	float distance = sqrt(position.x * position.x + position.y * position.y);
	vec3 axis = vec3(1.0, 0.0, 0.0);
	vec3 dir = normalize(position);

	float color = sin(dot(axis, dir) * 30.0 + sin(distance * 30.0 - time));
	color -= cos(sin(tan(distance * 10.0)));


	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}