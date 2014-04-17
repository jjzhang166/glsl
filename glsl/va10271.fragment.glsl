// another way to draw circles, antialiased. Psonice

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float r = 0.3; // radius of circle
float t = 0.01; // thickness of circle

void main( void ) {

	vec2 position = ( (gl_FragCoord.xy - resolution.xy*0.5) / resolution.x );
	
	float l = length(position); // distance from centre
	float d = abs(l-r); // distance from circle
	d /= t; // d gets scaled to circle thickness
	
	float s = pow(d, t * resolution.x*2.); // d value gets scaled so 0..1 range falls within 1px of the inner/outer parts of the circle to give us AA.
	
	s = clamp(1.-s, 0., 1.); // white on black, clamped to 0..1 range
	
	gl_FragColor = vec4( s );

}