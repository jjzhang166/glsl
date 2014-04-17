#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse; 
uniform vec2 resolution;

void main( void ) {

	vec2 xyZeroToOne = gl_FragCoord.xy / resolution;
gl_FragColor = vec4( xyZeroToOne.x, sin( time *2.0 ), sin(mouse.x), 1.0 );

}