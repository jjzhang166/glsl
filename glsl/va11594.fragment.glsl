#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	// Relax :)
	vec4 initialColor = gl_FragColor;
	vec3 color;
	color[0] = sin(time * mouse.x);
	color[1] = sin(time * mouse.x);
	color[2] = sin(time * mouse.y);
	
	gl_FragColor = vec4( color, 1.0 );
}