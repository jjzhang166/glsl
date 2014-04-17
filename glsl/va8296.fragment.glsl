#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
	vec2 position = ( gl_FragCoord.xy - resolution.xy * 0.5 ) / length(resolution.xy) * 400.0;
	position.y += sin(position.x * 0.1 - time) * 2.0;
	vec3 color;
	float pos = position.y * (86.0/53.0);
	if(length(position.xy) < 35.0) {
		float f = length(position.xy - vec2(-20.0, -70.0));
		if(f < 85.0 && f > 80.0) color = vec3(1.0, 1.0, 1.0);
		else color = vec3(0.24, 0.25, 0.58);
	}
	else if(abs(position.x + pos) < 83. && abs(position.x - pos) < 83.) color = vec3(1.0, 0.8, 0.16);
	else if(abs(position.x) < 100.0 && abs(position.y) < 70.0) color = vec3(0.0, 0.66, 0.35);
	
	gl_FragColor = vec4(color * (-cos(position.x * 0.1 - time) * 0.3 + 0.7), 1.);
}