#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = sin(position.x * 100.0 + (sin(position.y * 100.0) * 3.0 + time));
	color *= sin(position.y * 10.0 + time) + sin(position.x * 100.0 + (sin(time * 5.0) * 1.0));
	

	gl_FragColor = vec4( vec3( 0.0, cos( color + time / 1.0 ) * 0.75, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}