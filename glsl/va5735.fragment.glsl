#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//http://actionsnippet.com/?p=1451
float aDiff(float angle0,float angle1)
{
    return abs(mod((angle0 + PI -  angle1),PI*2.) - PI);
}

#define M_PI 2.71828182845904523536028747135266249775724709369995
#define N 10.0

vec3 sample(vec2 p)
{
	float color = 0.0;

	for (float i = 0.0; i < N; ++i) {
		float a = i * (5.0 * M_PI / N);
		color += cos( (p.x * cos(a) + p.y * sin(a)) + time ) / 2.0 + 0.5;
	}

	float m = mod(color, 2.0);
	if (m >= 1.0) color = 2.0 - m;
	else color = m;

	return vec3( color );
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

vec3 colour(const vec2 p,const vec2 l)
{
	vec3 c=sample(p);
	vec2 n=normal(p,0.01);

	return vec3(mix(c,vec3(0.5),max(dot(l,n),0.0)));
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy);
	
	vec2 m = mouse*resolution;
	
	vec3 color = vec3(0.0);
	
	vec3 pln = vec3(p,256.);
	
	vec3 lp = vec3(resolution/2.,0.0);
	vec3 ap = vec3(m,64.);
	
	float ax = asin(distance(vec3(lp.xy,pln.z),pln)/distance(lp,pln));
	float ay = atan(p.y-lp.y,p.x-lp.x);
	
	float lax = asin(distance(vec3(lp.xy,ap.z),ap)/distance(lp,ap));
	float lay = atan(ap.y-lp.y,ap.x-lp.x);
	
	color = vec3(1.-distance( vec2(ax,ay) , vec2(lax,lay)));
	
	color = vec3(1.-sqrt(pow(aDiff(ax,lax),2.)+pow(aDiff(ay,lay),2.)));
	color*=colour(p * resolution*0.001,vec2(0.5,0.5));//color = vec3(ax,ay,0.);
	
	gl_FragColor = vec4( color, 1.0 );

}