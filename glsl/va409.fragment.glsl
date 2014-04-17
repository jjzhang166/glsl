// Move mouse for most efficient seizure delivery

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 get(vec2 coord) {
	return texture2D(backbuffer, coord);
}

float tsin(float offset) {
	return (1.0 + sin(time * offset *( mouse.x + mouse.y))) / 2.0;
}

void main( void ) {
	vec2 d = gl_FragCoord.xy / resolution.xy;
	float dist = distance(d, vec2(0.5, 0.5));
	
	if (d.x > 0.5) d.x = d.x * 2.0 - 1.0;
	else d.x *= 2.0;
	
	if (d.y > 0.5) d.y = d.y * 2.0 - 1.0;
	else d.y *= 2.0;

	float z = (1.0 + sin(time)) / 2.0;
	gl_FragColor = dist < 0.2 ? vec4(tsin(3.0), tsin(5.0), tsin(7.0), 1.0) : get(d);
}