#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float proj = 4.0;
const int n = 4;

float getTexture(float u, float v)
{
	if (u > 0.5) u = 1.0 - u;
	if (v > 0.5) v = 1.0 - v;

	float value = 0.0;
	for (int i=0; i<n; i++)
	{
		float t = float(i) + (sin(time) * 0.5 + 0.5);
		value += sin(u * 14.0 * t) / t + sin(v * 7.0 * t) / t + sin(u * 8.0 * t + v * 14.0 * t) / t;
		value += sin(u * 4.0 * t) / t + sin(v * 27.0 * t) / t + sin(u * 38.0 * t + v * 18.0 * t) / t;
	}
	return value;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy - vec2(0.5);


	float v = mod(proj / abs(position.y) + time, 1.0);
	float u = mod(position.x * (proj / position.y) + sin(position.y * 8.0 + time), 1.0);

	float color = getTexture(u,v) * abs(position.y) * 0.5;

	if (u > 0.5) u = 1.0 - u;
	if (v > 0.5) v = 1.0 - v;
	gl_FragColor = vec4(vec3(color, color * v, color * u * (sin(2.5 * time) + 1.0)), 1.0 );

}