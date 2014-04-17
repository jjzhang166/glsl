#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D backbuffer;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)


float sqr( float x ) {
	return x * x;
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - .5 + (mouse - .5) * 3.;
	float ph = time * PI / 10.;
	float k1 = 20.;
	float ar = sqrt (sqr (position.x) + sqr (position.y));
	
	float r = sin(ph * .5) * sqr(cos(k1 * sqr(position.x) * cos(ph * .90
								  ) * 2. + ph * 5.)) * sqr(sin(k1 * sqr(position.y) * cos(ph * .7) * 2. + ph * 3.));
	float g = sin(ph * .7) * sqr(cos(k1 * sqr(position.x) * cos(ph * .5) * 2. + ph * 3.)) * sqr(sin(k1 * sqr(position.y) * cos(ph * .5) * 2. + ph * 5.));
	float b = sin(ph * 1.3) * sqr(cos(k1 * sqr(position.x) * cos(ph * .7) * 2. + ph * 2.)) * sqr(sin(k1 * sqr(position.y) * cos(ph * .3) * 2. + ph * 7.));
	
//	float r = .5 + .5 * cos (ar * 77. + ph * 10.);
//	float g = .5 + .5 * cos (ar * 55. + ph * 10.);
//	float b = .5 + .5 * cos (ar * 33. + ph * 10.);
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}


