#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	gl_FragColor = vec4( mod(floor(position * 10.0), sin(time * 10.0) * tan(time * 5.0)), 1.0, 1.0);

}