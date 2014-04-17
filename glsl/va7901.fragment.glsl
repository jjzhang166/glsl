#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );

	float c = sin(uv.x * 3.131592 * 10.0);

	gl_FragColor = vec4( c, c, c, 1.0 );

}