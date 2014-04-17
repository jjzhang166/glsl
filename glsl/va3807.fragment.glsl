//short code by T_S=RTX1911= @T_SDesignWorks
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 mouse;
uniform float time;

void main( void ) {gl_FragColor = vec4( mouse,0.5,1.0) + fract(1.0 - time * 2.0);}