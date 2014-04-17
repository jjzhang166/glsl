#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) { gl_FragColor = vec4( mod(time + cos(gl_FragCoord.x / 100.) * sin(gl_FragCoord.y / 100.0),1.)   );}