#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	float window = (cos(time + mouse.x) + 1.0) * 0.5;
	vec3 color = vec3( pow(mouse.x - position.x, 0.2), pow(position.y - mouse.y, 0.2) , window );
	gl_FragColor = vec4( color, 1.0 );
}