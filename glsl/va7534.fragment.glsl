#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
void main( void ) {
	vec4 col;
	if(abs(surfacePosition.x) < 10. && abs(surfacePosition.y) < 10.) col = vec4(255,0,0,1);
	else col = vec4(0,200,0,1);
	gl_FragColor = col;
}