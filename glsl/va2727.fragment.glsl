#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float gb = 1.0;
	if (position.y < 0.5)
		gb = 0.0;

	gl_FragColor = vec4( 1.0, gb, gb, 1.0);

}