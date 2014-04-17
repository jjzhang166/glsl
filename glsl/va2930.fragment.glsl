//something like Mr.doob's zoom blur
//but no so cool

//by nikoclass

//update: now with some stars

//update2: day and night sky

//update3: a smaller planet, but sky brightness should be calculated differently

//update4: um nikoclass, this looks awesome! one more thing: non-pixel-y planets and sun
#ifdef GL_ES
precision mediump float;
#endif


const int iterations = 100;

const vec3 day = vec3(0.3, 0.4, 0.8);
const vec3 night = vec3(0.05);
const vec3 sun = vec3(1.0, 1.0, 0.8);
const float fuzz = 0.005;
const float planetr = 0.03;
const float sunr = 0.1;
const float nightr = 0.2;
const float starr = 0.15;
	
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 m = mouse - 0.5;
float aspect = resolution.x / resolution.y;
float lp;
float lm;

vec3 getColor(vec2 position) {
	float dpm = distance(position, m);
	float lp = length(position);
	if (dpm < planetr) {
		return vec3(0.0);
	}
	
	vec3 c = day;
	if (lp < sunr) {
		c = sun;	
	} else if (lp < sunr + fuzz) {
		if (lm < nightr) c = mix(sun, mix(night, day, lm / nightr), (lp - sunr) / fuzz);
		else c = mix(sun, c, (lp - sunr) / fuzz);
	} else {
		if (lm < nightr) c = mix(night, day, lm / nightr);
	}
	if (dpm < planetr + fuzz)
		return c * (dpm - planetr) / fuzz;
	return c;
	
}

float rand(float x) {
	float res = 0.0;
	
	for (int i = 0; i < 5; i++) {
		res += 0.244 * float(i) * sin(x * 0.68171 * float(i));
		
	}
	return res;
	
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	position.x *= aspect;
	m.x *= aspect;
	
	lp = length(position);
	lm = length(m);
	
	vec3 color = getColor(position);		
		
	vec3 light;
	vec2 incr = position / float(iterations);
	vec2 p = vec2(0.0, 0.0) + incr;
	for (int i = 1; i < iterations; i++) {
		light += getColor(p);
		p += incr;
	}
	
	light /= float(iterations) * max(.01, dot(position, position)) * 50.0;
	
	vec2 star = vec2(gl_FragCoord);
	if (rand(star.y * star.x) >= 2.1 && rand(star.y + star.x) >= .7) {
		if (lm < starr && lp > sunr + fuzz) {
			color = mix(vec3(1.0), day, lm / starr);
		}
	}
	
	if (distance(position, m) < 0.03) {
		color = vec3(0.0);
	}
		
	gl_FragColor = vec4(color + light, 1.0);

}