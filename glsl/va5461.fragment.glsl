#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define N 9.0
#define ZOOM 10.0
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

vec3 sample(vec2 p)
{
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

	return vec3(r,g,b);
}

float lum(const vec3 cColour)
{
	const vec3 cLum=vec3(0.299,0.587,0.114);
	return dot(cColour,cLum);
}

vec2 normal(const vec2 p,const float fEps)
{
	vec2 e=vec2(fEps,0.0);

	return normalize(vec2(
		lum(sample(p+e.xy))-lum(sample(p-e.xy)),
		lum(sample(p+e.yx))-lum(sample(p-e.yx))));
}

void main( void ) {

	// This is a reimplementation of this thing:
	// http://mainisusuallyafunction.blogspot.no/2011/10/quasicrystals-as-sums-of-waves-in-plane.html
	
	vec2 p = ( gl_FragCoord.xy ) / 2.0 + mouse * resolution*0.3;
	p /= ZOOM;

	vec3 c=sample(p);

	vec2 n=normal(p,0.01);
	vec2 l=vec2(-0.3,-0.3); //mouse*2.0-1.0;

	float spec=dot(l,n);
	
	gl_FragColor=vec4(mix(c,vec3(0.5),spec),1.0);

}
