//short code by T_S=RTX1911= @T_SDesignWorks
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 mouse;
void main( void ) {gl_FragColor = vec4( mouse,0.5,1.0);}