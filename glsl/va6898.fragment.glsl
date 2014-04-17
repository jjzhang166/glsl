
#ifdef GL_ES
precision mediump float;
#endif

uniform float time; // TODO!

varying vec2 surfacePosition;

const int MAX_ITERATIONS = 60;
const vec2 SCALE = vec2(2, 2);
const vec2 OFFSET = vec2(-0.7, 0.0);

vec3 colorMap(float v)
{
	v *= 4.0;
	float r = min(v + 0.5, -v + 2.5);
	float g = min(v - 0.5, -v + 3.5);
	float b = min(v - 1.5, -v + 4.5);
 
	return vec3(g, b, r);
}

vec3 mandelbrot(vec2 c)
{
	vec2 r = vec2(0.0);
	for (int i = 0; i < MAX_ITERATIONS; ++i) {
		if (dot(r, r) > 4.0) {
			return colorMap(pow(float(i)/float(MAX_ITERATIONS), 0.8));
		}
		r = c + vec2(r.x*r.x - sin(time)*r.y*r.y*r.x - r.y*r.y, 2.0*r.x*r.y);
	}
	return vec3(0.0);
}

void main(void) {	
	vec2 position = surfacePosition * SCALE + OFFSET;
	gl_FragColor = vec4(mandelbrot(position), 1.0);
}