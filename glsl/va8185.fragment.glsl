#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;

const float tau = 3.1415926535897932384626433832795 * 2.0;

float hash (vec2 coord) {
	return fract(sin(dot(coord.xy, vec2(800.0, 160.0))) * 40000.0);
}

float noise (vec2 coord) {
	float left       = floor(coord.x);
	float top        = ceil(coord.y);
	float right      = ceil(coord.x);
	float bottom     = floor(coord.y);
	float weight;
	float weight_sum = 0.0;
	float hash_sum   = 0.0;
	vec2  corners[4];
	
	corners[0] = vec2(left, bottom);
	corners[1] = vec2(right, bottom);
	corners[2] = vec2(right, top);
	corners[3] = vec2(left, top);
	
	for (int i = 0; i < 4; i++) {
		weight      = max(1.0 - length(coord - corners[i]), 0.0);
		weight_sum += weight;
		hash_sum   += hash(corners[i]) * weight;
	}
	return hash_sum / weight_sum;
}

float cloud (vec2 coord) {
	const int   layer_count   = 6;
	const float first_wavelen = 20.0;
	const float wavelen_mul   = 0.5;
	const float mag_mul       = 0.7;
	
	float wavelen   = first_wavelen;
	float mag       = 1.0;
	float noise_sum = 0.0;
	float mag_sum   = 0.0;

	for (int i = 0; i < layer_count; i++) {
		mag_sum   += mag;
		noise_sum += noise(coord / wavelen) * mag;
		wavelen   *= wavelen_mul;
		mag       *= mag_mul;
	}
	return noise_sum / mag_sum;
}

float anim_polar_cloud (vec2 polar, float rate) {
	const float theta_scale  = 100.0;
	const float length_scale = 100.0;
	
	return pow(cloud(vec2(polar.x * theta_scale, (log(polar.y) - time * rate) * length_scale)), 2.0) * polar.y;
}

void main (void) {
	vec2 coord = (vec2(gl_FragCoord) / resolution - vec2(1.15, 0.5)) * vec2(resolution.x / resolution.y, 1.0);
	vec2 polar = vec2(abs(atan(coord.y / coord.x) * tau / 1.256), length(coord));
	vec3 color;
	
	color  = anim_polar_cloud(polar, 0.9) * vec3(0.9, 0.1, 0.0);
	color += anim_polar_cloud(polar, 0.5) * vec3(0.0, 0.1, 0.5);
	color += anim_polar_cloud(polar, 0.2) * vec3(0.0, 0.2, 0.0);
	gl_FragColor = vec4(color, 1.0);
}