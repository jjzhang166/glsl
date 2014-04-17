#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
	//nah!...not the same. Needs some adjustment to look as the original version.
	//is any documentation out there about how surfacePosition is being used here in heroku?
	//how JS prepares it?
	float x = surfacePosition.x;
	float y = surfacePosition.y;
	float col = x*100.0+sin(y*sin(time)*50.0);
	gl_FragColor = vec4(abs(sin(col)), abs(sin(col*.2+1.0)), abs(sin(col*.2)), 1.0 );
}