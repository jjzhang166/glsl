#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14;
float l  = 2.0; 		// Wave length
float f  = 1.0; 		// Frequency
float y0 = 0.2; 		// Amplitude
float w  = 2.0 * PI * f;	// Angular frequency
float k  = (2.0 * PI) / l; 	// Wave number

void main( void ) {
	
	// Normalize and center coord
	vec2 pos = (gl_FragCoord.xy / resolution.y);
	pos -= vec2((resolution.x / resolution.y) / 2.0, 0.5);
	
	float y = 2.0 * y0 * cos(w * time) * sin(k * pos.x);
	
	float color = 1.0 / (exp(abs(y - pos.y) * 50.0));
	
	gl_FragColor = vec4( vec3( color * 0.4, color * 0.4, color * 1.0 ), 1.0 );

}