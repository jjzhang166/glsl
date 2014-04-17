#ifdef GL_ES
precision mediump float;
#endif

//law of reflection? lol

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.0;

float l  = 4.0; 		// Wave length
float f  = 1.0; 		// Frequency
float y0 = 0.2; 		// Amplitude
float w  = 2.0 * PI * f;	// Angular frequency
float k  = l;//(2.0 * PI) / l; 	// Wave number

void main( void ) {
	
	// Normalize and center coord
	vec2 pos = (gl_FragCoord.xy / resolution.y);
	pos -= vec2((resolution.x / resolution.y) / 2.0, 0.5);
	float t=1.0;
	float y =  y0 * pow(pos.x * (mouse.x * 10.0), 0.999);
	
	float color = 1.0 / (exp(abs(y - pos.y) * 50.0));
	
	gl_FragColor = vec4( vec3( color * 0.4, color * 0.4, color * 1.0 ), 1.0 );

}