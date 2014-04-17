precision mediump float;

uniform vec2 mouse;

void main () {
	gl_FragColor = vec4 (1.0, 0.5, 0.25, 1);
	
	float dist = length(mouse.xy - gl_FragCoord.xy);
	float intensity = 0.5 / dist;
	
	gl_FragColor = vec4 (gl_FragColor.r * intensity, gl_FragColor.g * intensity, gl_FragColor.b * intensity, 1);
	}