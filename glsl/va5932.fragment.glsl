#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// wave dance - bonniemathew@gmail.com
void main( void ) {
	
	float FREQUENCY_FACTOR = 20.0;
	float AMPLITUDE_FACTOR = 0.3;
	float LINE_WIDTH = 10.0;
	float WAVE_OFFSET = 0.1;
	
	vec4 color_final;
	vec3 color = vec3(0.0, 0.0, 0.);
	float wX1, wY1;
	float wX2, wY2;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	
	wX1 = position.x;
	wY1 = sin(wX1 * FREQUENCY_FACTOR + time * 2.0) * AMPLITUDE_FACTOR;
	
	wX2 = position.x + WAVE_OFFSET;
	wY2 = cos(wX2 * FREQUENCY_FACTOR  - time * 2.0) * AMPLITUDE_FACTOR;
	
	float distFromWave1 = abs(1.0 - length(position - vec2(wX1, wY1)));
	position.x += WAVE_OFFSET;
	float distFromWave2 = abs(1.0 - length(position - vec2(wX2, wY2)));
	LINE_WIDTH = mouse.y * 200.0;
	
	color += ((distFromWave1/LINE_WIDTH) * 100.0);
	color *= ((distFromWave2/LINE_WIDTH) * 100.0);
	
	color_final = vec4(color.x * 0.5,  color.y * 0.3 , color.z * 0.0, 1.0);
	gl_FragColor = color_final;
}