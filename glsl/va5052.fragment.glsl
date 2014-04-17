#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
void main( void ) {
	vec2 GraphPos = surfacePosition;
	float colorr = cos(GraphPos.y+time)+cos(GraphPos.x+time);
	float colorg = sin(GraphPos.y-time)+cos(GraphPos.x+time);
	float colorb = sin(GraphPos.y-time)+sin(GraphPos.x-time);
	gl_FragColor = vec4(colorr,colorg,colorb, 1.0 );
}