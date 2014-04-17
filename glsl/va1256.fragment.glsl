//created by niko
//nikoclass@gmail.com

//note: best looking at level 1 or 0.5

//update1: added very simple light scattering

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec2 sunPosition = vec2 (0.7, 0.20);

const int iterations = 50;

float noise1(in float x) {
	return abs(sin(x * 300.0));	
}

vec3 getColor(vec2 position) {

	vec3 color = vec3(0.6, 0.7, 1.0);
	
	vec2 posFixed = position * vec2 (1, resolution.y / resolution.x);
	float distToSun = distance(posFixed, sunPosition);
	
	if (distToSun < 0.04) {
		color = vec3(1.0, 1.0, 0);	
	}
	
	color = mix (vec3(1.0, 1.0, 0), color,  min(distToSun * 7.0, 1.0));
	
	position.x += sin(time) * position.y * 0.1 * (sin(position.x * 30.0 + time) * 0.2);
	
	if (noise1(position.x) > position.y * 1.5 + noise1(position.x * 2.736) * 0.2) {
		color = vec3(0.4, 0.4, 0.0) * (clamp(position.y * 4.0, 0.0, 1.0));	
	}
	
	return color;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec3 color = getColor(position);
	
	vec2 sunFixed = sunPosition * vec2 (1, resolution.x / resolution.y);
	vec2 actualPos = position;
	vec2 dir = (position - sunFixed) / float(iterations);
	
	vec3 lightColor;
	float attenuation = 2.0;
	for (int i = 0; i < iterations; i++){
		actualPos -= dir;
		vec3 c = getColor(actualPos);
		if (length(c) >= sqrt(2.0)) {
			lightColor += vec3(attenuation);
		}
		attenuation *= 0.96;
	}
	lightColor /= float(iterations);
	gl_FragColor = vec4(color + lightColor , 1);

}
