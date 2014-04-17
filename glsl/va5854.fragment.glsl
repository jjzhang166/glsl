#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float AMPLITUDE = 1.0;
float EULER_NUMBER = 2.718281828;
float x0 = 0.5;
float y0 = 0.5;
float spreadX = 0.1;
float spreadY = 0.2;

float gauss2d(float x, float y) {
	return pow(AMPLITUDE * EULER_NUMBER, -1.0 * ( (pow(x-x0, 2.0) / (2.0 * pow(spreadX, 2.0)) ) +  (pow(y-y0, 2.0) / (2.0 * pow(spreadY, 2.0)) ) ));
}
		   
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float intensidade = gauss2d(position.x, position.y);
	
	gl_FragColor = vec4( vec3(0.5 + (intensidade * 0.5), 0.2 * intensidade, 0), 1.0 );
}