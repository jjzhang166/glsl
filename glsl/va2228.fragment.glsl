//@micgdev
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution) - mouse;
	
	float c = sin( p.x * cos( time / 15.0 ) * 80.0 ) + cos( p.y * cos( time / 15.0 ) * 8.0 );

	gl_FragColor = texture2D(bb, p) + vec4(c * 2.5, c, c - sin(time / 2.), 1.);

}