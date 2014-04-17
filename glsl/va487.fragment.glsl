#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float waveLength = .01;//aktually fwequensee
float PI = 3.14159265358979323846264;

void main( void ) {
	float sumx = 0.0 * (time * 0.1);
	float sumy = 0.0 * (time * 0.1);
	for(float i = 0.0; i < .6; i += 0.05){
		vec2 p1 = vec2(i, .5) * sin(time * .5) * cos(time / PI);

		float d1 = 1. - length(gl_FragCoord.xy/resolution - p1) * (time * 0.01);

		float wave1x = sin(d1 / waveLength * PI) * atan(mouse.x, mouse.y);
		float wave1y = cos(d1 / waveLength * PI) * atan(mouse.y, mouse.x);
		sumx = wave1x + sumx;
		sumy = wave1y + sumy;
	}
	gl_FragColor = vec4(sqrt(pow(sumx , 2.) + pow(sumy , 2.)) / (5.),0,0,1.);

}