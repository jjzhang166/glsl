#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define MOUSE_SIZE 0.05
#define MOUSE_SIZE_X MOUSE_SIZE * (resolution.y / resolution.x)
#define MOUSE_SQUARE 0
#define MOUSE_CIRCLE 1

#define FADE 0.92

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution;

#if MOUSE_SQUARE
	if (abs(position.x - mouse.x) < MOUSE_SIZE_X &&
	    abs(position.y - mouse.y) < MOUSE_SIZE) {
#endif
#if MOUSE_CIRCLE
	if (length( position.xy - mouse.xy ) < MOUSE_SIZE ) {
#endif
	    gl_FragColor = vec4(sin(time), -sin(time), cos(time), -cos(time)) * 0.5 + 0.5;
	    return;
	}
	
	gl_FragColor = texture2D(backbuffer, position) * FADE;
}