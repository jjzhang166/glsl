#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//const int iterations = 1;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 pix = gl_FragCoord.xy / resolution.xy;
	
	float p = pix.x;
	float iterations = 0.;
	while ( p < 0. || p > 1. )
	{
		// growing
		p += .1;
	}
	
	gl_FragColor = vec4( iterations );
	
//	float color = o;
//	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}