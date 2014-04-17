#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - mouse;



	gl_FragColor = vec4( vec3( 1.0,1.0,1.0) * vec3(position.x*sin(time*0.5),position.y*cos(time*0.5),sin(time)) , 1.0 );

}