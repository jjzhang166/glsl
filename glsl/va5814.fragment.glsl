#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = clamp(sin(atan(position.y / sin(mouse.y), position.x + .0)/(sin(mouse.x) + 0.1)), 0.0, 1.0 + time);
	gl_FragColor = vec4( color / (sin(mouse.x) + 0.1), color / (sin(mouse.y) + 0.1), color, 1.0 );
}