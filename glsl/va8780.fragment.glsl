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

#define N 50
void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;
	v /= 10.0;
	//v.x += 1.0;
	//vec2 m = normalize(mouse) * 0.5;
	vec2 m = mouse;
	//m /= 2.0;
	float cx = -m.x + sin(time) * 0.01;//-0.5;
	float cy = -m.y + cos(time) * 0.01;//-0.5;
	
	float x = v.x;
	float y = v.y;
	
	//float x = 0.0;
	//float y = 0.0;
	
	float f = 0.0;
	
	vec2 shift = vec2( 0.0, 1.0 );
	float i2 = 0.0;
	for ( int i = 0; i < N; i++ ){
		x = abs(x);
		y = abs(y);
		//if(x < 1000.0 || y < 1000.0)
		//	break;
		float m = x*x + y*y;
		m =m + sin(m);
		//m *= m;
		x = x/m + cx;
		y = y/m + cy;
		cy +=x * 0.00001 * f;
		cx +=y * 0.00001 * f;
		i2++;
		f += sqrt(m);
	}
	
	
	//f = sin(f);
	vec3 col = vec3(sin(f - 0.2), sin(f), sin(f + 0.2));
	col *= col * col;
	gl_FragColor = vec4(col, 1.0);
}