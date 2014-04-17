#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rand ( int i, float e ) {
	return vec2 ( .02 * sin ( 55.5 * mod ( floor (time * 11.7) * e * ( 1.4 + float ( i * 3 ) ) , 1.0 ) ) ,
		      .02 * sin ( 43.5 * mod ( (time * 9.4) * e * ( 1.6 + float ( i * 2 ) ) , 1.0 ) ) );
}


float line ( vec2 a , vec2 b, float s ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float aspect = resolution.x / resolution.y;
	vec2 lab = a - b, la = pos - a, lb = pos - b;
	lab.x *= aspect; la.x *= aspect; lb.x *= aspect;
	float d = ( length ( la ) + length ( lb ) - length ( lab ) + 1e-6 )
		* min ( length ( la ) , length ( lb ) );
	s += max ( 3. - pow ( d * 4.3e8 , 0.07 ) , 0.0 );
	return s;
}

float split ( vec2 a , vec2 b , int k, float s  ) {
	a += rand ( 6, .1 );
	vec2 t = a;
	vec2 d = ( b - a ) / float ( k );
	for ( int i = 1 ; i < 20 ; ++i ) {
		if ( i > k ) return(s);
		vec2 v = a + d * float(i);
		v += rand ( i , .1 );
		s = line ( t , v, s );
		t = v;
	}
	return(s);
}

void main( void ) {
	float c;
	c = split ( vec2 ( .5 , 1. ) , .5 + rand ( 0 , 0.019 ) * 5. , 6, c );
	c = split ( .5 + rand ( 0 , 0.019 ) * 5. , vec2 ( 0.3 + rand ( 0 , 0.19 ).x * 5. , 0.0 ) , 10, c );
	c = split ( vec2 ( .5 , 1. ) , vec2 ( 0.7 + rand ( 0 , 0.19 ).x * 5. , 0.0 ) , 11 , c);
	
	gl_FragColor = vec4( c - .2 , c -= rand(4,.1).x , c , 1.0 );

}