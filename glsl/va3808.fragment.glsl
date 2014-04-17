//short code by T_S=RTX1911= @T_SDesignWorks
#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 mouse;
uniform float time;

void main( void ) {gl_FragColor = vec4((mouse-0.75),sin(tan(time*1.25)*2.0),1.0) + fract(1.0 - time * 10.0);}