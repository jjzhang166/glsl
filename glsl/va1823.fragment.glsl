#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float distFromMouse = sqrt((gl_FragCoord.x - (mouse.x * resolution.x)) * (gl_FragCoord.x - (mouse.x * resolution.x)) + (gl_FragCoord.y - (mouse.y * resolution.y)) * (gl_FragCoord.y - (mouse.y * resolution.y)));
	
	gl_FragColor = vec4(sin(distFromMouse * time), cos(distFromMouse  * (2.0 + time)), tan(distFromMouse * time), 1.0);
}