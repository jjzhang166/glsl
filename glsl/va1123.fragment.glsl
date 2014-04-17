#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Matrix

void main( void ) {	
	gl_FragColor = vec4( 0, -mod(gl_FragCoord.x +time*1. , cos(gl_FragCoord.y/840.+3.14)+0.004)*.5, 0 ,1);
}