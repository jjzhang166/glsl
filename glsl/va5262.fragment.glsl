#ifdef GL_ES
precision mediump float;
#endif

// First test of recursive rotozoomer.
// by Optimus

// gotta save this unfinished version atm because I am late for an appointment :)

// ..continued 12/2012 as pseudo flower zoomer fractal generator by deepr

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	position.x *= position.x;
	vec2 centered_position = position - vec2(0.5+0.02*sin(time*0.2), 0.5+0.02*cos(time));
	vec3 color = vec3(0.0);

	vec3 test = 0.7130*vec3(sin(centered_position.x * 24.0) * 0.30 +0.0, sin(centered_position.y * 1.0) * 0.0 + 0.0, sin(centered_position.x * 32.0 + centered_position.y * 1.0) * 0.20);

	if (abs(centered_position.x) > 0.495 || abs(centered_position.y) > 0.495)
	{
		color = test;
	}
	else if (abs(centered_position.x) > 0.4875 || abs(centered_position.y) > 0.4875)
	{
		color += vec3(0.5*sin(time*7.0));
	}
	else
	{
		float angle = time * (0.005);
		float xp = centered_position.x * sin(angle) - centered_position.y * cos(angle);
		float yp = centered_position.x * cos(angle) + centered_position.y * sin(angle);
		centered_position = vec2(xp, yp) * (1.0+0.1*sin(time*1.1));
		color = texture2D(backbuffer, centered_position + vec2(0.5)).rgb;
	}

	gl_FragColor = vec4(color, 1.0) * (pow(length(centered_position), 0.00015));
}