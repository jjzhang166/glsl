// Memorized colourful line by Dima..
// Use your mouse!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D buffer;

const float dr = 0.003;
const float k = dr + 2. * dr * 50.;

vec3 color;
void line ( vec2, vec2 b );

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 last = texture2D ( buffer , vec2 ( dr ) ).rb;
	if ( pos.x < 2. * dr && pos.y < 2. * dr ) color.rb = mouse;
	else
	for ( float i = 3. * dr ; i < k ; i += 2. * dr ) {
		vec2 inf = texture2D ( buffer , vec2 ( i , dr ) ).rb;
		if ( pos.y < 2. * dr ) { if ( pos.x > i - dr && pos.x < i + dr ) color.rb = last; }
		else line ( last , inf );
		last = inf;
	}
	
	gl_FragColor.rgb = color;

}

void line ( vec2 a , vec2 b ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x / resolution.y;
	a.x *= aspect; b.x *= aspect; pos.x *= aspect;
	float d = distance ( pos , a ) + distance ( pos , b ) - distance ( a , b ) + 1e-5;
	color.b += max ( 1. - pow ( d * 14. , .2 ) , -.01 );
	color.r += sin ( color.b ) * .5;
	color.g += sin ( color.r ) * .5;
}