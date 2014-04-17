// Awful timer by Dima..
// Code can also be used to output such information as resolution or mouse position

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int d_tt = 0x01;
const int d_tr = 0x02;
const int d_tl = 0x04;
const int d_cc = 0x08;
const int d_dr = 0x10;
const int d_dl = 0x20;
const int d_dd = 0x40;
const int d_ff = 0x7F;
int d_v[10];

float s;

void line ( vec2 a, vec2 b ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float d = distance ( pos , a ) + distance ( pos , b ) - distance ( a , b ) + 1e-5;
	s += max ( 1. - pow ( d * 14. , 0.2 ) , -0.01 );
}

void digit ( int spec , vec2 offset , vec2 size ) {
	if ( spec >= d_dd ) { spec -= d_dd; line ( offset                                 , offset + vec2 ( size.x , .0          ) ); }
	if ( spec >= d_dl ) { spec -= d_dl; line ( offset                                 , offset + vec2 ( .0     , size.y * .5 ) ); }
	if ( spec >= d_dr ) { spec -= d_dr; line ( offset + vec2 ( size.x , .0 )          , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_cc ) { spec -= d_cc; line ( offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_tl ) { spec -= d_tl; line ( offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( .0     , size.y      ) ); }
	if ( spec >= d_tr ) { spec -= d_tr; line ( offset + vec2 ( size.x , size.y * .5 ) , offset + size ); }
	if ( spec >= d_tt ) { spec -= d_tt; line ( offset + vec2 ( .0     , size.y )      , offset + size ); }
}

void draw ( float dig , vec2 offset , vec2 size ) {
	// Ugly bisect	
	if ( dig < 4.5 ) {
	if ( dig < 2.5 ) {
	if ( dig < 0.5 )           digit ( 119 , offset , size ); //0
	else if ( dig < 1.5)       digit ( 18  , offset , size ); //1
	else                       digit ( 107 , offset , size ); //2
	} else {
	if ( dig < 3.5 )           digit ( 91  , offset , size ); //3
		else               digit ( 30  , offset , size ); //4
	}
	} else {
	if ( dig < 7.5 ) {
	if ( dig < 5.5 )           digit ( 93  , offset , size ); //5
	else if ( dig < 6.5)       digit ( 125 , offset , size ); //6
	else                       digit ( 19  , offset , size ); //7
	} else {
	if ( dig < 8.5 )           digit ( 127 , offset , size ); //8
		else               digit ( 95  , offset , size ); //9
	}
	}
}

void main( void ) {

	float d0 = floor ( mod ( time * 1.e+2 , 10. ) );
	float d1 = floor ( mod ( time * 1.e+1 , 10. ) );
	float d2 = floor ( mod ( time * 1.e+0 , 10. ) );
	float d3 = floor ( mod ( time * 1.e-1 , 10. ) );
	float d4 = floor ( mod ( time * 1.e-2 , 10. ) );
	float d5 = floor ( mod ( time * 1.e-3 , 10. ) );
		
	draw ( d0 , vec2 ( .73 , .50 ) , vec2 ( .050 , .200 ) );
	draw ( d1 , vec2 ( .65 , .50 ) , vec2 ( .050 , .200 ) );
	draw ( d2 , vec2 ( .51 , .300 ) , vec2 ( .075 , .300 ) );
	draw ( d3 , vec2 ( .39 , .300 ) , vec2 ( .075 , .300 ) );
	draw ( d4 , vec2 ( .27 , .300 ) , vec2 ( .075 , .300 ) );
	draw ( d5 , vec2 ( .15 , .300 ) , vec2 ( .075 , .300 ) );
	
	gl_FragColor = vec4( vec3( s , .0 , s * ( sin ( time * 5. ) * .5 + .5 ) ), 1.0 );

}