#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	vec2 coord = position * sin(time) * 0.1;
	
	// flashlight
	float light = 0.7 - clamp(distance(resolution.xy * vec2(sin(time) * cos(-time) / 5.0 + 0.5, cos(time) / 5.0 + 0.5), gl_FragCoord.xy) * 0.006, 0.0, 1.0);
	
	// effect
	float color = cos(coord.y * time + sin(coord.x * time)) * sin(time);
	color += cos(coord.x * time + sin(coord.y * time)) * 0.6;
	
	color = abs(color) * light * cos(time);
	
	gl_FragColor = vec4(color * position.x, color * position.y, color, 1.0) * vec4(position.y , color * position.x, color, 2.0);
}