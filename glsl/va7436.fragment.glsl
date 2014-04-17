#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy);

	gl_FragColor = vec4( vec3( 1. - position.x, 1. - abs(position.x*2. - 1.) , position.x), 1.0 );
}