#ifdef GL_ES
precision mediump float;
#endif
// www.seb.cc
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float color = 0.0;
	color+=mod(sin(position.x+time*0.1)+position.x*position.y*sin(position.y+time*0.2)*sin(position.x-time*0.22),0.001)*1000.;
	gl_FragColor = vec4( vec3( color ), 1.0 );

}