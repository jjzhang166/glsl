#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*
 * inspired by http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
 * a slight(?) different 
 * public domain
 */

#define N 60
void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;

	float xsum = 0.0;
	float ysum = 0.0;
	float pi2 = 3.1415926535 * 2.0;
	float C = cos(mouse.x * pi2 + 0.01*sin(time*.3));
	float S = sin(mouse.x * pi2 + 0.01*sin(time*.3));
	vec2 shift = vec2( C, S ) * (mouse.y+.5)*1.0;
	float zoom = (1.0 + 0.01*cos(time*0.3));
	float weight = 1.0;
	
	for ( int i = 0; i < N; i++ ){
		float rr = v.x*v.x+v.y*v.y;
		if ( rr > 1.0 ){
			rr = 1.0/rr;
			v.x = v.x * rr;
			v.y = v.y * rr;
		}
		if ( i > 10 ){
			weight *= 0.95;
			xsum += v.x*v.x * weight;
			ysum += v.y*v.y * weight;
		}
		
		v = v * zoom + shift;
		v = vec2( v.x*v.x-v.y*v.y, 2.0*v.x*v.y );
	}
	
	float col = sqrt(xsum*ysum);


	gl_FragColor = vec4( cos(ysum*2.0), cos(xsum*2.0), cos(col*2.0), 1.0 )*.7+.5;

}