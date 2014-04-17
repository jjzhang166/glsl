#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define N 80

vec4 fractal( vec2 v, vec2 m ){
	float x = v.x;
	float y = v.y;
		
	for ( int i = 0; i < N; i++ ){
		if ( x*x + y*y > 16.0 )
			return vec4( log(1.0+float(i))/log(1.0+float(N)), 0, 0, 1.0);
			
		float x2 = x * x - y * y + m.x;
		float y2 = 2.0 * x * y + m.y;
		
		x = x2;
		y = y2;

	}
	return vec4( 0, 0, 0.0, 0 );
}

void main( void ) {

	// fragcoord to pos
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 2.0;
	
	// mouse to pos
	vec2 m = (mouse* resolution - resolution/2.0)  / min(resolution.y,resolution.x) * 2.0 ;

	float ring1 = length(v);
	
	vec4 color = fractal( v, m );
	if ( 1.00 <= ring1 && ring1 < 1.01 ){
		color.g += 0.3;
	}
	else if (length(v-m) < 0.02) {
		color.g +=0.3;
	}
	gl_FragColor = color;
}
