#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float square(float val) {
	return mod(val, 2.0) > 1.0 ? 1.0 : 0.0;
}

float rect(float val, float dutycycle) {
	return mod(val, 2.0) > (dutycycle * 2.0) ? 1.0 : 0.0;
}

float wavebytime(float val, float magnitude, float speed, float offset) {
	return val + magnitude*sin(speed*time + offset);
}

void main( void ) {

	const float pi = 3.14159295;
	
	/* Change the following parameters for super-happy-fun-fun-go-time. */
	
	const float thickness = 0.1; /* Thickness of lines */
	const float speed = 1.0; /* Speed of waving */
	const float wavyness = 1.0; /* Amplitude of waving */
	const bool invert = true; /* Whether colors should be inverted */
	float spacing = pi/2.0; /* Spacing between red/green/blue components */
	
	vec4 xbrightness = vec4(
		rect(wavebytime(gl_FragCoord.x / 20.0, wavyness, speed, 0.0), thickness),
		rect(wavebytime(gl_FragCoord.x / 20.0, wavyness, speed,	spacing), thickness),
		rect(wavebytime(gl_FragCoord.x / 20.0, wavyness, speed, 2.0*spacing), thickness),
		1.0);
	
	vec4 ybrightness = vec4(
		rect(wavebytime(gl_FragCoord.y / 20.0, wavyness, speed, pi/2.0), thickness),
		rect(wavebytime(gl_FragCoord.y / 20.0, wavyness, speed, pi/2.0 + spacing), thickness),
		rect(wavebytime(gl_FragCoord.y / 20.0, wavyness, speed, pi/2.0 + 2.0*spacing), thickness),
		1.0);

	vec4 brightness = xbrightness * ybrightness;
	
	if(invert)
		brightness = vec4(1.0, 1.0, 1.0, 0.0) - brightness;
	
	gl_FragColor = brightness;
}