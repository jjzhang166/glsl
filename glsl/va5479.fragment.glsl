#ifdef GL_ES
precision mediump float;
#endif

// This should be the starting point of every effect - dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.1415926535897932384

float derp(float angle, float d) {
	float x = 1.0;
	//x *= sin(angle*3.)*0.5;
	//x *= sin(sin(angle*1.)*1.+time*7.)*0.5;
	x += 0.5;
	x *= sin(d*128. - time*20.)*0.5;

	return x;
}

float herp(vec2 pos, vec2 dpos) {
	vec2 position = (( pos / resolution.xy ) - 0.5) / vec2(resolution.y/resolution.x, 1.0) + dpos;
	float angle = atan(position.y,position.x);
	float d = length(position);
	return derp(angle, d);
}

void main( void ) {
	vec3 color = vec3(1., 0., 0.);

	vec2 a = vec2(cos(time * 0.6) * 0.2, sin(time * 0.5) * 0.2);
	vec2 b = vec2(cos(time * 0.3) * 0.2, sin(time * 1.0) * 0.2);
	vec2 c = vec2(cos(time * 0.2) * 0.2, sin(time * 0.2) * 0.2);

	color.r = herp(gl_FragCoord.xy, a);
	color.r += herp(gl_FragCoord.xy, b);
	color.r += herp(gl_FragCoord.xy, c);

	color.r += 0.9;
	if (color.r < 0.) color.r = 0.;
	else if (color.r > 1.) color.r = 1.;

	color.r = pow(color.r, 6.0);
	color = vec3(color.r);

	gl_FragColor = vec4(color, 1.0);
}