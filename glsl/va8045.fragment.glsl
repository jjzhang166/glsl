#ifdef GL_ES
precision highp float;
#endif

//lunar

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323846264;

//floating wave function so everyone could understand =) you're welcome
float wave(in float value, in float amplitude, in float ferquency, in float wavelength ) {
	float wavenum = 2.0 * PI / wavelength;
	float phase = wavenum * value;
	return amplitude * cos(ferquency*time+phase); //use sin if y
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float c = 0.0;
	float timer = ((sin(time)*0.15+0.15)+0.4); //1.1
	float count = 0.0;
	for (int i = 0; i < 25; i++) {
		count += 1.0;
		if ( (position.y) < timer-0.05*count + wave(position.x, 0.01*count, 5.0, 0.2 + 0.1 * count) ) { 
			if (i == 0) { c = 1.0; } else {
				c *= 0.95; 
			}
		}
	}
	
		
	
	gl_FragColor = vec4( vec3( c * timer / 3.0, c * timer, c), 1.0);

}