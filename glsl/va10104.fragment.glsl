#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//inspired by http://lodev.org/cgtutor/plasma.html
void main( void ) {
	float x = gl_FragCoord.xy.x/resolution.x;
	float y = gl_FragCoord.xy.y/resolution.y;
	float col = sin(x*20.0)+1.0+sin(y*20.0)+time;
	gl_FragColor = vec4(abs(sin(col)), abs(sin(col*.5+1.0)), abs(sin(col*.2)), 1.0 );
}