#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	gl_FragColor = vec4(smoothstep(length(gl_FragCoord.xy) / 300.0, 1.0, mouse.x), 1.0, 1.0, 1.0);

}