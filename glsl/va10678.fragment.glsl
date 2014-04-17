#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	
	vec2 position = gl_FragCoord.xy / resolution.x - 0.5;

	gl_FragColor = vec4( position.x * mouse.x, position.y + mouse.y, position.x * sin(time), position.y + cos(2. * time) );

}