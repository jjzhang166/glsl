#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 color;

vec2 center ( vec2 border , vec2 offset , vec2 vel ) {
	vec2 c = offset + vel * time;
	c = mod ( c , 2. - 4. * border );
	if ( c.x > 1. - border.x ) c.x = 2. - c.x - 2. * border.x;
	if ( c.x < border.x ) c.x = 2. * border.x - c.x;
	if ( c.y > 1. - border.y ) c.y = 2. - c.y - 2. * border.y;
	if ( c.y < border.y ) c.y = 2. * border.y - c.y;
	return c;
}

void circle ( float r , vec3 col , vec2 offset , vec2 vel ) {
	vec2 pos = gl_FragCoord.xy / resolution.y;
	float aspect = resolution.x / resolution.y;
	vec2 c = center ( vec2 ( r / aspect , r ) , offset , vel );
	c.x *= aspect;
	float d = distance ( pos , c );
	color += col * ( ( d < r ) ? 0.5 : max ( 0.8 - min ( pow ( d - r , .3 ) , 0.9 ) , -.2 ) );
}
	
void main( void ) {

	circle ( .03 , vec3 ( 0.7 , 0.2 , 0.8 ) , vec2 ( .6 ) , vec2 ( .30 , .20 ) );
	circle ( .05 , vec3 ( 0.7 , 0.9 , 0.6 ) , vec2 ( .6 ) , vec2 ( .30 , .20 ) );
	circle ( .07 , vec3 ( 0.3 , 0.4 , 0.1 ) , vec2 ( .6 ) , vec2 ( .30 , .20 ) );
	circle ( .10 , vec3 ( 0.2 , 0.5 , 0.1 ) , vec2 ( .6 ) , vec2 ( .30 , .20 ) );
	circle ( .20 , vec3 ( 0.1 , 0.3 , 0.7 ) , vec2 ( .6 ) , vec2 ( .30 , .20 ) );
	circle ( .30 , vec3 ( 0.9 , 0.4 , 0.2 ) , vec2 ( .6 ) , vec2 ( .30 , .20 ) );
	
	gl_FragColor = vec4( color, 1.0 );

}