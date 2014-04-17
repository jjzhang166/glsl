#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy ;
	

	gl_FragColor = vec4( sin(50.0*p.x)/sin(50.0*p.y),sin(50.0*p.x)/-sin(50.0*p.y),sin(50.0*p.y)*sin(50.0*p.x),0 );
}