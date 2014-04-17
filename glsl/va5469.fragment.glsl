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

	//edit: manually unrolled the loop for my obviously broken shader compilers // fnord
		float i, a, t;
	
		i = 1.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 2.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 3.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 4.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 5.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 6.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 7.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 8.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	
		i = 9.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	/*
		i = 10.;
		a = i * (2.0 * M_PI / N);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time * SPEED ) / 2.0;
		t = sqrt(abs(t));
		r += t + 0.5 + 0.2 * i;
		g += t + 1.0 + 0.4 * i;
		b += t + 1.5 + 0.6 * i;
	*/
		
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


vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

void main( void ) {
	vec2 aspect = vec2(1.0, resolution.y/resolution.x);
	vec2 p = (( gl_FragCoord.xy / resolution.xy )) * aspect;
	p = mix( -0.5 + (p- 0.5)*8., complex_div(vec2(4.,.0), p - mouse*aspect) + 0.5, 0.5); 
	p /= ZOOM;

	vec3 c=sample(p);

	vec2 n=normal(p,0.01);
	vec2 l=vec2(-0.3,-0.3); //mouse*2.0-1.0;

	float spec=dot(l,n);
	
	gl_FragColor=vec4(mix(c,vec3(0.5),spec),1.0);

}
