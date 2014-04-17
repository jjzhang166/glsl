// MERRY CHRISTMAS

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = 1.0 - ( gl_FragCoord.xy / resolution.xy ) * 2.0;

	gl_FragColor = vec4(asin(sin(atan(p.x, p.y) * 4.0 + length(p) * 16.0 + time * 8.0)), asin(sin(atan(p.y, p.x) * 2.0 + length(p) * 24.0 + time * 8.0)), 0.0, 1.0) * pow(length(p), 0.8);
}