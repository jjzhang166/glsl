#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = fract(position.x * 100.0 + (fract(position.y * 100.0) * 3.0 + time));
	color *= fract(position.y * 10.0 + time) + fract(position.x * 100.0 + (fract(time * 5.0) * 1.0));
	

	gl_FragColor = vec4( vec3( 0.0, fract( color + time / 1.0 ) * 0.75, fract( color + time / 3.0 ) * 0.75 ), 1.0 );

}