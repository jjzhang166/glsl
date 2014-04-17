#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323846

void main( void ) {

	if(abs(gl_FragCoord.y - (sin(gl_FragCoord.x/-1.5959+time)*40.0+resolution.y/2.0)) < 4.0)gl_FragColor = vec4(1.0);
}