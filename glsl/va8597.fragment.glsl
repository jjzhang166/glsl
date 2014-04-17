
precision mediump float;
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
	float _lumBlue = lum + blue ; 
	return vec3(  _lumBlue );
}

void main( void ) {
	// normalize position
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	vec3 result =  vec3(77.0 / 255.0 , 182.0 / 255.0 , 254.0 / 255.0 );
	result += combo(position, 0.95+0.05*sin(0.6*time + 4.0*position.x), 0.15);
	result += combo(position, 0.85+0.05*sin(0.7*time + 3.0*position.x), 0.55);

	// 77 , 182 , 254 - bg
	// 97 , 243 , 251 
	gl_FragColor = vec4(result, 1.0);
}
