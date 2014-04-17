#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 line ( float x, vec2 pos, vec2 a , vec2 b )
{
	float d = distance ( pos , a ) + distance ( pos , b ) - distance ( a , b ) + 1.e-7;
	d = max ( 0.0, 0.5 - pow(d,1.07)*112.2 );
	d = pow ( d , 3.0 );
	return vec3 ( d * x * .5, d * ( 10.0 -  x) * .2 * ( 2. * x + abs(cos ( time )) ) * .2, d * .5 * abs (sin (time + x)));
}

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.y;
	pos.x -= 1.0 - resolution.y / resolution.x;
	
	vec3 s = vec3 (0.0);
	const float pi = 3.14159265;
	
	for ( float x = 0.0 ; x < 2.0 * pi - 0.01 ; x += pi / 15.0 )
	{
		vec2 upper = vec2 ( .5 + sin ( time + x ) * .2, .25 + cos ( time + x ) * .05 );
		vec2 lower = vec2 ( .5 - sin ( time + x - pi * .3 ) * .2, .75 + cos ( time + x - pi * .4  ) * .05 );
		s += line ( x, pos, upper , lower );
	}
	
	gl_FragColor = vec4( s, 1.0 );

}