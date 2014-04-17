#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy  ;
	float c = 0.0 ;
	float a = atan(p.y, p.x)*30.0 ;

	gl_FragColor = vec4( 0.5,vec2( cos(time + a ) ), 1.0 );

}