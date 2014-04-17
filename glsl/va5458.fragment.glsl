#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define N 9.0
#define ZOOM 1.0
#define SPEED 0.5

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float post_process(float color) {
	float m = mod(color, 2.0);
	if (m >= 1.0)
		color = 2.0 - m;
	else
		color = m;
	return color;
}

vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p = mix( -0.5 + (p- 0.5)*8., complex_div(vec2(0.25,.0), p - mouse) + 0.5, 0.5); 
	p /= ZOOM;
	p += vec2(20);

	vec3 color = vec3(0.0);
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	for (float i = 0.0; i < N; ++i) {
		float a = i * (2.0 * M_PI / N);
		float t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	}
	
	r = post_process(r);
	g = post_process(g);
	b = post_process(b);

	gl_FragColor = vec4( r, g, b, 1.0 );

}
