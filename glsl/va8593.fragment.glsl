#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 50
float tc = cos(time);
float ts = sin(time);

vec4 fractal( vec2 v, vec2 m ){
	float x = v.x;
	float y = v.y;
		
	float r = 0.0;
	float a = 0.5;
	float p = 0.456789;
	for ( int i = 0; i < N; i++ ){
		r = x*x + y*y;
		if ( r > 1000.0 )
			return vec4( float(i)/float(N), 1.0, 1.0, 1.0);
		
		float xx = x * m.x - y * m.y + x/r;
		float yy = x * m.y + y * m.x - y/r;
		
		a = fract( a + p );
		if ( a < 0.5 ) xx += 1.0;
		else xx -= 1.0;
		
		x = xx;
		y = yy;

	}

	return vec4(0.0,0.0,0.0,1.0);

}

void main( void ) {

	// fragcoord to pos
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 1.0;
	
	// mouse to pos
	vec2 m = (mouse* resolution - resolution/2.0)  / min(resolution.y,resolution.x) * 0.1 ;

	
	
	float ring1 = length(v);
	
	vec4 color = fractal( v, vec2( m.x+ ts*0.03, m.y+ tc*0.03 ) );
	if ( 1.00 <= ring1 && ring1 < 1.01 ){
		//color.g += 0.3;
	}
	else if (length(v-m) < 0.02) {
		//color.g  +=0.3;
	}
	gl_FragColor = color;
}

