#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592
#define N 8
#define S 10.

// B

float noise(float s)
{
	return mod(sin(s * 431.) + sin(s * 1234. + .1) + sqrt(s * 100.) + mod(s, .4), 1.);
}

float interp(float a, float b, float x)
{
	return a + (b - a) * (cos(PI * x) * -.5 + .5);
}

float pnoise(float s)
{
	float is = float(int(s));
	return interp(noise(is), noise(is + 1.), s - is);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) + time / 10.;
	
	float x = p.x * S;
	float y = p.y * S;
	float color = pnoise(x) * pow(.5, float(N)) * sin(time) * 100.;
	for(int i = 0; i < N; i++)
	{
		color += pnoise(x * float(i)) * pow(.25, float(i));
		color += pnoise(y * float(i)) * pow(.25, float(i));
	}
	
	float r = mod(color, .125) + color;
	float g = mod(color, .25);
	float b = mod(color, .5);
	gl_FragColor = vec4( r, g, b, 1. );

}