// http://www.youtube.com/watch?v=-z8zLVFCJv4

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0 - (mouse*2.0-1.0);
	p.x *= resolution.x / resolution.y; // aspect ratio

	float r = sqrt( dot( p, p ) );
	float a = atan( p.y, p.x ) + time * 0.1;
	float s = 0.5 + 0.5 * sin( 3.0 * a );

//Nick
	float t = 0.15 + 0.35 * pow( s, 0.3 );
	t += 0.1 * pow( 0.8 + 0.5 * cos( 6.0 * a ), 0.9 );
	float h = r/t;
	float f = 0.0;
	if ( h < 1.0 ) f = 1.0;
	gl_FragColor = vec4( mix( vec3( 1.0 ), vec3( 0.5 * h, 0.5 + 0.5 * h, 0.0 ), f ), 1.0 ); 

}