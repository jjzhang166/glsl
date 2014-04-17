#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	vec2 coord = position * 0.2;
	
	
	// flashlight
	float light = 1.0 - clamp(distance(resolution.xy * mouse, gl_FragCoord.xy) * 0.05, 0.0, 1.0);
	
	// effect
	float color = cos(coord.x * time + sin(coord.y * time)) * 0.4;
	color += cos(coord.y * time + sin(coord.x * time)) * 0.6;
	
	color = abs(color) * light * 1.5;
	//color = abs(color) * 1.5;

	
	//gl_FragColor = vec4(color * position.x, color * position.y, color, 1.0);
	gl_FragColor = vec4(color * position.x, color * position.y, color, 1.0);
}