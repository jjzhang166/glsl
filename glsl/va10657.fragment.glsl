#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi, a, r, R, s;

float rts ( float x, float lo, float hi, float k ) {
	if ( x < lo )
		return max ( 0.0, 1.0 - ( lo - x ) * k );
	if ( x < hi )
		return 1.0 + min ( hi - x, x - lo ) / ( hi - lo );
	return max ( 0.0, 1.0 - ( x - hi ) * k );
}


float rta ( float aa, float ab ) {
	float k = 5.0;
	return max ( rts ( a            , aa , ab , k ), 
	       max ( rts ( a - 2.0 * pi , aa , ab , k ), 
		     rts ( a + 2.0 * pi , aa , ab , k ) ) );
}

void main( void ) {

	s = 0.0;
	pi = 2.0 * atan ( 1.0, 0.0 );
	r = length ( gl_FragCoord.xy - mouse * resolution );
	a = atan ( gl_FragCoord.y - mouse.y * resolution.y , gl_FragCoord.x - mouse.x * resolution.x ); 
	R = min ( resolution.x , resolution.y ) / 4.0;
	a += mod ( time , 2.11 );
	
	s += rts ( r , R / 1.1 , R , 0.3 ) + rts ( r , R / 5.0 , R / 3.7 , 0.3 ) +
		rts ( r,  R / 2.7 , R / 1.2 , 0.1 ) * 
			( rta ( -pi / 3.0 , 0.0 ) + rta ( -pi , -2.0 * pi / 3.0 ) + rta ( pi / 3.0 , 2.0 * pi / 3.0 ) );
	
	gl_FragColor = vec4( s , s * 0.81 , s - 1.0 , 1.0 );
}