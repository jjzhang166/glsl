#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415927;
const float EPSILON = .001;

const float NUMBER_OF_STEPS = 150.;
const float MAXIMUM_DEPTH = 10.;

vec4 noise(vec4 seed)
{
	return(fract(cos(mod(mod(seed, vec4(5612.)), vec4(PI * 2.))) * vec4(56812.5453)));
}

float smooth_noise(vec3 seed)
{
	seed = mod(seed + 32768.0, 65536.0);

	vec3 k = fract(seed) * fract(seed) *(3. - 2. * fract(seed));

	vec4 l = noise(vec4(0., 57., 113., 170.) + dot(floor(seed), vec3(1., 57., 113.)));
	vec4 m = noise(vec4(1., 58., 114., 171.) + dot(floor(seed), vec3(1., 57., 113.)));
	
	l = mix(l, m, k.x);
	
	float t = mix(mix(l.x, l.y, k.y), mix(l.z, l.w, k.y), k.z);

	return 1. - 2. * t;
}

float perlin(vec3 position)
{
	return smooth_noise(position * .06125) * .5 +
	       smooth_noise(position * .125) * .25 +
	       smooth_noise(position * .25) * .125;
}

void rotate_x(inout vec3 position, float angle)
{
	vec3 cache = position;
	
	float sine = sin(angle);
	float cosine = cos(angle);
	
	position.y = cosine * cache.y - sine * cache.z;
	position.z = sine * cache.y + cosine * cache.z;
}

void rotate_y(inout vec3 position, float angle)
{
	vec3 cache = position;
	
	float sine = sin(angle);
	float cosine = cos(angle);
	
	position.x = cosine * cache.x + sine * cache.z;
	position.z = -sine * cache.x + cosine * cache.z;
}

void rotate_z(inout vec3 position, float angle)
{
	vec3 cache = position;
	
	float sine = sin(angle);
	float cosine = cos(angle);
	
	position.x = cosine * cache.x - sine * cache.y;
	position.y = sine * cache.x + cosine * cache.y;
}

void repeat_x(inout vec3 position, float count)
{
	float w = 2. * PI / count;
	
	float a = atan(position.z, position.x);
	float r = length(position.xz);
	
	a = mod(a + PI * .5, w) + PI - PI / count;
	position.xz = r * vec2(cos(a), sin(a));
}

float sphere(vec3 position, float radius)
{
	return length(position) - radius;
}

float round_box(vec3 position, float span, float radius)
{
	return length(max(abs(position) - span, 0.)) - radius;
}

float scene(vec3 position)
{
	float l = sphere(position - vec3(0., .15, 0.), .1);
	float m = sphere(position + vec3(0., .15, 0.), .1);
	
	return min(m, l);
}

float shadow(vec3 position, vec3 light, float step_size) {
	float coefficient = 0.;
	
	for (float i = 5.; i > 0.; --i) {
		coefficient += scene(position + light * i * step_size);
	}
	return clamp(coefficient, 0., 1.);
}

void main(void)
{
	vec2 optics = (gl_FragCoord.xy / resolution.xy) * 2. - 1.;
	optics.x *= resolution.x / resolution.y;
	
	vec3 origin = vec3(0., 0., -1.);
	vec3 direction = normalize(vec3(optics - origin.xy, -origin.z));
	
	vec4 color = vec4(1.);
	
	for (float i = 0.; i < 1.; i += 1. / NUMBER_OF_STEPS) {
		vec3 position = origin + direction * i;
		float d = scene(position);
		
		if (d < EPSILON) {
			vec3 normal = normalize(vec3(
				scene(position + vec3(EPSILON, 0., 0.)) -
				scene(position - vec3(EPSILON, 0., 0.)),
				scene(position + vec3(0., EPSILON, 0.)) -
				scene(position - vec3(0., EPSILON, 0.)),
				scene(position + vec3(0., 0., EPSILON)) -
				scene(position - vec3(0., 0., EPSILON))
			));

			vec3 light = normalize(vec3(cos(time), sin(time), 0.));
			
			color = vec4(dot(normal, light)) * shadow(position, -light, .1);
			break;
		}
	}	
	
	gl_FragColor = color;

}