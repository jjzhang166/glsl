#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float wave(float angle, float amplitud, float translation)
{
	return translation + amplitud * sin(angle);
}

float waveOfWave(float angle, float translation1, float translation2, float translation3)
{
	return wave(translation1 + wave(angle, 0.4, translation2), 0.4, translation3);
}

vec4 waves(float separation, vec2 pos)
{
	vec4 cbuff;
	for(float i = 0.0; i < 3.0; i++){
		float nd = waveOfWave(time/100.0, 2.0*pos.x, i*separation+time, pos.x) - pos.y;
		float amnt = abs(0.01/nd);
		cbuff += vec4(amnt*sin(time/10.0), amnt, amnt*pos.y, 0.0);
	}
	return cbuff;
}

void main( void ) {
	gl_FragColor = waves(0.5, gl_FragCoord.xy / resolution);
}
