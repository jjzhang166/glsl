#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float waveLength = .01;//aktually fwequensee
float PI = 3.14159265358979323846264;

void main( void ) {
	//float produkt = 1.;
	float sumx = 0.;
	float sumy = 0.;
	for(float i = 0.4; i < .6; i += 0.05){
		vec2 p1 = vec2(i, .5);

		float d1 = 1. - length(gl_FragCoord.xy/resolution - p1);

		float wave1x = sin(d1 / waveLength * PI);
		float wave1y = cos(d1 / waveLength * PI);
		sumx = wave1x + sumx;
		sumy = wave1y + sumy;
		//produkt = produkt * wave1;
	}
	gl_FragColor = vec4(sqrt(pow(sumx , 2.) + pow(sumy , 2.)) / (5.),0,0,1.);

}