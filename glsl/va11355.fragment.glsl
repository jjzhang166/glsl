#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159265359;
const float PERIOD = 3.0; //seconds

const int SQUARE_SIZE = 20;

const float MUE = 0.5;
const float SIGMA = 0.30;

float gauss(float x, float mue, float sigma) {
	float a = x-mue;
	return	exp(-a*a/(2.0*sigma*sigma))/(sqrt(2.0*PI)*sigma);
}

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy )*PI*float(GRID_SIZE);
	vec2 position = mod(gl_FragCoord.xy,float(SQUARE_SIZE))/float(SQUARE_SIZE);
	float mixture = sin( PI*mod(time, PERIOD)/PERIOD );
	
	float intensity = gauss(position.x,MUE,SIGMA)*gauss(position.y,MUE,SIGMA);	
	float color = mixture * intensity + (1.0-mixture) * (1.0-intensity);
	
	gl_FragColor = vec4( vec3( color, 0.0, 0.0 ), 1.0 );
}