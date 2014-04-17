#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159265359;

float circle(vec2 pos, float time, float height, float amplitude, float y){
	float wave = sin(pos.x * PI + time) * amplitude * y;
	wave = wave - pos.y - height * sin(time * 0.1);
	return pow(abs(wave), 0.1) * sign(wave);
}

void main( void ) {
	vec2 pos = (gl_FragCoord.xy / resolution) * 2.0 - vec2(1.0, 1.0);
	float y = cos(pos.y * PI * 0.5);
	float normal = 0.5;
	float height = 1.0;


	for (int i = 1; i <20; i++) {
		float index = float(i) / 20.0;
		float sinus = circle(pos, time * .09 / index, 0.95, .5, y);
		float newNormal = sinus * 0.5;

		if (newNormal < 0.0) {
			newNormal += 1.0;
		}

		normal = mix(newNormal, normal, abs(sinus) + index * 0.125);
		height *= abs(sinus);
	}
	
	normal = clamp(normal, 0.0, 1.0);
	normal = normal * 2.0 - 1.0;
	if (abs(normal) > 0.2) {
		normal -= pow(sin((abs(normal) - 0.2) * 1.25 * PI * 0.5), 1.1) * sign(normal);
	}
	normal = normal * 0.5 + 0.5;



	gl_FragColor = vec4(vec3(normal), 1.0 );
}