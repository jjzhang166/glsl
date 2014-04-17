#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

struct Point {
	vec4 col;
	float powv;
};
Point point;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	p.x *= resolution.x/resolution.y;
	
	point.col = vec4( 1,0,0,1 );
	point.powv = 100.0;
	
	vec4 col = vec4( 0,0,0,1 );
	float dist = 1.0-length( p - gl_FragColor.xy );
	vec4 c = point.col * pow( dist,point.powv );
	col += c;
	gl_FragColor = col;
}
