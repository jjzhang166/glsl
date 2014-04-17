#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getStuff(float u, float v)
{
	float value = pow(mod(sin(u) + sin(v) + sin(u*v), 2.0), 2.0);
	if (value > 1.0) value = 2.0 - value;
	return value;
}

void main( void ) {

	float z = 256.0 / (gl_FragCoord.y - resolution.y / 2.0);
	float x = (256.0 * z) / (gl_FragCoord.x - resolution.x / 2.0);

	float v = mod(z + time, 1.0);
	float u = mod(x + time, 1.0);
	if (u > 0.5) u = 1.0 - u;
	if (v > 0.5) v = 1.0 - v;


	float color = getStuff(u,v) / abs(x);
	gl_FragColor = vec4( vec3(color * sin(u + v), color * sin(x), color * sin(z)), 1.0 );

}