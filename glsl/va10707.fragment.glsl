// Real Line by Dima..
// This is a line, computed using General Linear Equation. It helps to find out a distance to line.
// For the corners of segment I used a distance to ones.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*
--Line--
A*x1 + B*y1 + C = 0 
A*x2 + B*y2 + C = 0
A * ( x1 - x2 ) + B * ( y1 - y2 ) = 0
A = y2 - y1;
B = x1 - x2;
С = x1 ( y1 - y2 ) + y1 ( x2 - x1 )
A*x + B*y + C = y2*x - y1*x + x1*y - x2*y + x1*y1 - x1*y2 + y1*x2 - y1*x1 
	    = xy * AB + x1y1 * ( -AB )
Distance = ( A*x + B*y + C ) / ( A*A + B*B )

--Corners--
PA^2 = AB^2 + PB^2 - 2 * cos (A)
PB^2 = AB^2 + PA^2 - 2 * cos (B)
so if PA^2 - PB^2 - AB^2 > 0
   or PB^2 - PA^2 - AB^2 > 0
that means
      | PA^2 - PB^2 | > AB^2
then A or B greater than 90 degrees, so point is outside a segment
*/

float col;

void line ( vec2 a , vec2 b , float w , float s ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x / resolution.y;
	a.x *= aspect; b.x *= aspect; pos.x *= aspect;
	// = Line
	vec2 v = vec2 ( b.y - a.y , a.x - b.x );
	float d = ( dot ( pos , v ) + dot ( a , -v ) ) / sqrt ( dot ( v , v ) );
	// = Corner
	vec2 pa = pos - a , pb = pos - b, ab = a - b;
	float da = dot ( pa , pa ) , db = dot ( pb , pb ) , dl = dot ( ab , ab );
	if ( abs ( da - db ) > dl ) 
		d = min ( sqrt ( da ) , sqrt ( db ) ); 
	// = Apply
	col = step ( abs ( d ) , w ) + ( 1. -  abs ( d * 10. ) ) * s;
}

void main( void ) {

	line ( vec2 ( .5 ) , mouse , sin ( time * 5.0 ) * .01 + .015 , sin ( time * 1. ) );
	
	gl_FragColor = vec4( vec3( col * 0.5 , 0.0 , col ), 1.0 );

}