#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p =  gl_FragCoord.xy ;
	float a = sin(p.x) ;
	float b = sin(p.y);
	float c = 5.0*cos(p.x)+cos(p.y);

	

	gl_FragColor = vec4( a, b,c,0 );

}