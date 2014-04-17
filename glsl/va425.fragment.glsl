#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
if (sin(time)< 0.1) {
	gl_FragColor = vec4( 1.0, 1.0, 0.0, 1.0 );
    }
/*
if (cos(time)< 0.5) {
	gl_FragColor = vec4( 0.0, 1.0, 0.0, 1.0 );
 } else {
    if (sin(time)< 0.1) {
	gl_FragColor = vec4( 1.0, 1.0, 0.0, 1.0 );
    }
 }
*/
}