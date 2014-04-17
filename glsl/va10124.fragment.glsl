#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float x = gl_FragCoord.xy.x/resolution.x;
	float y = gl_FragCoord.xy.y/resolution.y;
	float col = x*100.0+sin(y*sin(time)*50.0);
	gl_FragColor = vec4(abs(sin(col)), abs(sin(col*.2+1.0)), abs(sin(col*.2)), 1.0 );
}