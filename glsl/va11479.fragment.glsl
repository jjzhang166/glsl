#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 3.0 );

	float color = 0.0;
	color += position.xy - 3.0;

	gl_FragColor = vec4( vec3( color, color - 10.5, sin( color * time / 1.0 ) * 0.75 ), 0.0 );

}