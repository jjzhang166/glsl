#ifdef GL_ES
precision mediump float;
#endif
#define pi 3.141592653589793238462643383279

uniform float time;
uniform vec2 resolution;
uniform vec3 color;

// How fast it animates
float tscale = 1.1;

float wave(vec2 position, float freq, float height, float speed) {
	float result = sin(position.x*freq - time*tscale*speed);
	result = result * -10.0 -4.0;
	result *= height;
	return result;
}

vec3 combo(vec2 position, float center, float size) {
	
	float offset = pi * (center - 111.9);
	float lum   = abs(tan(position.y * pi + offset)) - pi/2.0;
	lum *= size;
	
        
	
	float blue = wave(position, 1.5, -.1*size, 1.0);
	
	return vec3( lum + blue );
}

void main( void ) {
	// normalize position
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	vec3 result = color; //vec3(11.0, 25.0, 0.0);
	result += combo(position, 0.95+0.05*sin(0.6*time + 4.0*position.x), 0.05);
	result += combo(position, 0.85+0.05*sin(0.7*time + 3.0*position.x), 0.05);

	gl_FragColor = vec4(result, 1.0);

}