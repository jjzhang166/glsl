//Brain-Damage

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	gl_FragColor=vec4(sin(gl_FragCoord.x/resolution.x*400.0*time),cos(gl_FragCoord.x/resolution.x*400.0*time),sin(gl_FragCoord.x/resolution.x*300.0*time),1.0);

}