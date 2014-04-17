#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
void main( void ) { gl_FragColor = vec4( cos(time * 5.), sin(mouse.x), sin(mouse.y), 1.0 ); }

// @danbri learning: show how to shade each pixel's REDness by cosine of time; 
// GREENness from mouse's x position, and BLUEness from mouse's y position.

