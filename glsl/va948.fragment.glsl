#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	position.x -= 0.5;
	position.y -= 0.5;

	float distance = sqrt(position.x * position.x + position.y * position.y);
	vec2 axis = vec2(0.0, 1.0);
	vec2 dir = normalize(position);

	float color = cos(dot(axis, dir) * 30.0 + sin(distance * 30.0 - time));
	color -= cos(sin(tan(distance * 10.0)));


	gl_FragColor = vec4( vec3( color, color * 0.64, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	

}