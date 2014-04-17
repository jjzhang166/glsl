#ifdef GL_ES
precision mediump float;
#endif
 
uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

vec2 pol2cart(float r, float t) {
	return vec2(r * cos(t), r * sin(t));
}

float rand(float x, float y){
	return fract(sin(dot(vec2(x, y) ,vec2(12.9898,78.233))) * 43758.5453);
}

float sawtooth(float t) {
	return t - floor(t);
}

const float PI = 3.14159;

const int starCount = 150;
const float starSize = 2.0;
const float speed = 0.3;

void main(void)
{
	vec2 center = resolution / 2.0;
	
	float sum = 0.0;
	for (int i = 0; i < starCount; i++) {
		float offset = 50.0 + 50.0 * rand(float(i), 20.0);
		float age = sawtooth((time * speed - 40.0 * rand(float(i), 2.1)) - 20.0);
		
		float r = offset + mix(0.0, resolution.y, age);
		float t = (2.0 * PI) * (float(i) / float(starCount)) + 30.0 * rand(float(i), 3.1);
					
		float brightness = age / 1.0;
		
		vec2 position = pol2cart(r, t) + center;
		

		float dist = length(gl_FragCoord.xy - position);
		
		sum += starSize * brightness / (dist * dist);
	}
	
	vec4 buffer = texture2D(backbuffer,1.0 - (gl_FragCoord.xy / resolution))*0.8;
	gl_FragColor = vec4(sum * 0.4, sum * 0.5, sum, 1) + buffer;
}
