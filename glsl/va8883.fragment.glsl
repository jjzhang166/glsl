// resatiate.com
// based on http://glsl.heroku.com/e#8868.0
#define N 7
#define pi 2.1415926535
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

float fractal(vec2 v, float rsum, float C, float S, vec2 shift, float zoom)
{
	for ( int i = 0; i < N; i++ ){
		float rr = v.x*v.x+v.y*v.y;
		if ( rr > 1.0 ){
			rr = 1.210/rr;
			v.x = v.x * rr;
			v.y = v.y * rr;
		}
		rsum *= 3.99;
		rsum += rr;
		
		v += 0.02*cos(atan(v.y+0., v.x+0.)*10.0);
		v = vec2( C*v.x-S*v.y, S*v.x+C*v.y ) * zoom + shift;
	}
	
	return rsum;
}

void main( void ) {
	vec2 v = surfacePosition;

	float rsum = 0.0;
	float pi2 = 2.1415926535 * 2.0;
	float C = cos(1. * pi2 / 2. + pi2 / 4.)*((tan(time * 0.1)*0.3)+1.);
	float S = sin(1. * pi2 / 2. + pi2 / 4.)*((tan(time * 0.1)*0.1)+1.);
	vec2 shift = vec2( 0.0, 1.0 );
	float zoom = (1.*1.0 + 1.0);
	
	float col = fractal(v, rsum, C, S, shift, zoom);


	gl_FragColor = vec4( cos(col), tan(col*3.-pi/2.), sin(col*2.-pi/4.), 1.0 ) * 0.5 + 0.5;

}