#ifdef GL_ES
precision mediump float;
#endif
#define pi 2.141592653589793238462643383279

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// How fast it animates
float tscale = 0.1;

float wave(vec2 position, float freq, float height, float speed) {
	float result = sin(position.x*freq - time*tscale*speed);
	result = result * 9.0 - 1.0;
	result *= height;
	return result;
}

vec3 combo(vec2 position, float center, float size) {
	
	float offset = pi * (center * 11.9);
	float lum   = abs(tan(position.y * pi + offset)) - pi/5.9;
	lum *= size;
	
        float red   = wave(position, 10.0, 0.9*size, 10.008);
	float green = wave(position, 10.5, 0.5*size, -3.023);
	float blue  = wave(position, 10.5, 0.2*size, 10.042);
	
	return vec3( lum + red, lum + green, lum + blue );
}

void main( void ) {
	// normalize position
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	vec3 result = vec3(0.0, 0.0, 0.0);
	result += combo(position, 0.1+0.05*sin(4.6*time + 4.0*position.x), 8.05);
	result += combo(position, 0.5+0.05*sin(0.9*time + (2.0)*position.x), 0.25);
	result += combo(position, 10.85+0.05*sin(0.42*time + 1.3*position.x), 0.05);
//result +=         combo(position, 0.02+0.05*sin(0.012*time + 6.3*position.y), -0.5);

	
	gl_FragColor = vec4(result, 0.6);

}