#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define N 9.0
//#define ZOOM 10.0
float ZOOM = 1.;
#define SPEED 0.5

//TV effect. Just wait to see..

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float post_process(float color) {
	float colorSpan = 10. * sin(time/100.);
	float m = mod(color, colorSpan);
	if (m >= 1.0)
		color = 1.8 - m;
	else
		color = m;
	return color;
}

void main( void ) {

	// This is a reimplementation of this thing:
	// http://mainisusuallyafunction.blogspot.no/2011/10/quasicrystals-as-sums-of-waves-in-plane.html
	
	//ZOOM = sin(time);
	
	
	vec2 p = ( gl_FragCoord.xy ) / 2.0 + mouse * resolution*0.3;
	p /= ZOOM;
	p += vec2(30);

	vec3 color = vec3(0.0);
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	for (float i = 0.0; i < N; ++i) {
		float a = i * (2. * M_PI / N);
		float t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(t*99999.);
		r += t + 0.5 + 99.8 * i;
		g += t + 1.0 + 77.4 * i;
		b += t + 1.5 + 0.6 * i;
	}
	
	r = post_process(r);
	g = post_process(g);
	b = post_process(b);

	gl_FragColor = vec4( r, g, b, 1.0 );

}
