#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define R 4.0
#define RM 7.0
#define G 6.0
#define GM 7.0
#define B 6.0
#define BM 7.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	// This is a reimplementation of this thing:
	// http://mainisusuallyafunction.blogspot.no/2011/10/quasicrystals-as-sums-of-waves-in-plane.html
	
	vec2 position = ( gl_FragCoord.xy ) / 2.0 + mouse * resolution*0.3;

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	for (float i = 0.0; i < R; ++i) {
		float a = i * (2.0 * M_PI / RM);
		r += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 4.0 + 0.5;
	}
	float m = mod(r, 2.0);
	if (m >= 1.0) r = 2.0 - m;
	else r = m;
	
	for (float i = 0.0; i < G; ++i) {
		float a = i * (2.0 * M_PI / GM);
		g += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 4.0 + 0.5;
	}
	m = mod(g, 2.0);
	if (m >= 1.0) g = 2.0 - m;
	else g = m;
	
	for (float i = 0.0; i < B; ++i) {
		float a = i * (2.0 * M_PI / BM);
		b += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 3.0 + 0.5;
	}
	m = mod(b, 2.0);
	if (m >= 1.0) b = 2.0 - m;
	else b = m;

	gl_FragColor = vec4(r, g, b, 1.0 );

}
