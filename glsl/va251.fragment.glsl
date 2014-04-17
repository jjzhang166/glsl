#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int divergent = 128;

int julia( vec2 pos, vec2 zero ) {
	float x = zero.x;
	float y = zero.y;
	int n = 0;
	for ( int i = 0; i < divergent; i++ ) {
		if ( (x*x - y*y) > 1.0 ) {
			return n;
		}
		float new_x = x*x - y*y + pos.x;
		float new_y = 2.0*x*y + pos.y;
		x = new_x;
		y = new_y;
		n += 1;
	}
	return divergent;
}	
void main( void ) {
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) - 2.0)  * 1.0 + (mouse + 0.5) * 2.0;
	vec2 zero = vec2( sin(time/5.0), cos(time/5.0) );
	int n = julia( position, zero );
	
	float color = float(n) / float(divergent);
	gl_FragColor = vec4( vec3( color, 0.0, 0.0 ), 0.2 );
}