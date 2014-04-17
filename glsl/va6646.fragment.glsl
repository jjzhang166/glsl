#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int iter = 40;
float square(float a)
{
	float sum = 0.0;
	float ebin = 1.0;
	for(int i = 0; i< iter; i++)
	{
		sum -= sin(a * ebin) / ebin;
		ebin += 1.0 + cos(time * 0.1);
	}
	return sum;
}

float wave(float a)
{
	return square(a);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	
	float color = 0.0;
	
	if(abs(wave(time * 3.0 + position.x * 20.0) * .03 - position.y + .3) < 0.001)
		color = 1.;
	gl_FragColor = vec4( vec3(color), 1.0 );

}


