#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 p1 = .3 * vec2(sin(time), sin(1.23 * time)) + vec2(.5,.5);
	vec2 p2 = mouse;
	float d1 = 1. / (1. + exp( 40. * distance(position, p1) - .6));
	float d2 = 1. / (1. + exp( 40. * distance(position, p2) - .6));
	float v = d1 + d2;

	gl_FragColor = vec4( v,v,v, 1.0 );

}