#ifdef GL_ES
precision mediump float;
#endif

// First test of recursive rotozoomer.
// by Optimus

// gotta save this unfinished version atm because I am late for an appointment :)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 centered_position = position - vec2(0.5);

	vec3 color = vec3(0.0);

	if (abs(centered_position.x) > 0.495 || abs(centered_position.y) > 0.495)
	{
		color = vec3(0.5);
	}
	else if (abs(centered_position.x) > 0.475 || abs(centered_position.y) > 0.475)
	{
		color = vec3(1.0);
	}
	else
	{
		float angle = time * 0.5;
		float xp = centered_position.x * sin(angle) - centered_position.y * cos(angle);
		float yp = centered_position.x * cos(angle) + centered_position.y * sin(angle);
		centered_position = vec2(xp, yp) * 1.15;
		color = texture2D(backbuffer, centered_position + vec2(0.5)).rgb - 0.025;
	}

	gl_FragColor = vec4(color, 1.0) * (pow(length(centered_position), 0.05));
}