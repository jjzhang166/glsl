#ifdef GL_ES 
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//AMIGA Look.... ;-)

void main( void ) {	
	gl_FragColor = vec4( 0, -mod(gl_FragCoord.x +time*51. , cos(gl_FragCoord.y/841.+3.14)+0.04)*1.5, 0 ,1);
	
	
}