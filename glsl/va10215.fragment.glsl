#ifdef GL_ES
precision mediump float;
#endif

#define AUDIO_RATIO 25.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec3 normal; 

void main( void ) {

	gl_FragColor = vec4(time, 0.0, 0.32, 1.0); 
}