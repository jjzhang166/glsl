#ifdef GL_ES
precision mediump float;
#endif

// Some Atlanta Frag-o

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;

	float x = atan(position.x*0.8+cos(time),position.y+12.0*sin(position.y+position.x+time));
	gl_FragColor = vec4( 0.3, 0.4 * cos(x), 0.4 * sin(x+time), 1.0 );
}