#ifdef GL_ES
precision mediump float;
#endif

#define NUM_BALLS 10

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec4 color_out;
uniform vec3 balls[NUM_BALLS];

bool energyField(vec2 p, float gooeyness, float iso) {
	float en = 0.0;
	bool result = false;
	
	for (int i=0; i<NUM_BALLS; ++i) {
		float radius = balls[i].z;
		float denom = max(0.0001, pow(length(vec2(balls[i].xy - p)), gooeyness));
		en += (radius / denom);
	}
	
	if (en > iso)
		result = true;
	
	return result;
}

void main( void ) {
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y - cos(time);
	float n = sin(sin(p.x) * sin(p.y)) + sin(p.y - p.x) + sin(p.x - time) * dot(p.x, p.y);
	//n += dot(pow(n, p.x), n);
	
	color_out.g += clamp(mod(p.x + n, 0.5), 0.0, 1.0);
	color_out.g += clamp(mod(p.x + n, 0.5), 0.0, 1.0);
	color_out.r = clamp(color_out.g, 0.0, 1.0);
	color_out.g = clamp(mod(p.x + n, 0.5), 0.0, 1.0);
	color_out.b = clamp(mod(p.x + n, 0.5), 0.0, 1.0);
	
	gl_FragColor = color_out;
}