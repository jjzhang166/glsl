#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	uv.x = 1. - uv.x;
	gl_FragColor = vec4( uv.xy, 0., 1.);
}