#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

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

	return vec3(mix(c,vec3(0.5),dot(l,n)));
}

void main(void)
{
	vec2 p = ((gl_FragCoord.xy) / resolution.xy);
	float aspect = resolution.x / resolution.y;
	vec2 center = vec2(0.5, 0.5);
	
	//ugly code! needs to be cleaned up
	
	vec3 lightColor = vec3(0.8, 0.4, 0.6);

	float Angle = degrees(atan(mouse.y-center.x, mouse.x-center.y));
	float Azimuth =  0.0;
	float zr = radians(Angle);
	float yr = radians(Azimuth);
	vec3 dir = vec3(-sin(yr));
	float a = cos(yr);
	dir.x = a * cos(zr);
	dir.y = a * sin(zr);
	vec3 SpotDir = normalize(dir);

	float d = distance(p, center);
	vec3 attenuation = vec3(0.5, 10.0, 100.0);
	float shadow = 1.0 / (attenuation.x + (attenuation.y*d) + (attenuation.z*d*d));

	float s = clamp(sin(time*2.0)/2.0+0.5, 0.75, 1.0);

	vec3 delta = normalize(vec3(p, 0.0) - vec3(center, 0.0));
	float fDist=length(mouse-vec2(0.5,0.5))*80.0;

  	float cosOuterCone = cos(radians(0.0+fDist));
	float cosInnerCone = cos(radians(20.0+fDist));
  	float cosDirection = dot(delta, SpotDir);

	float influence=smoothstep(cosInnerCone, cosOuterCone, cosDirection) * shadow;
	vec3 color = vec3(colour(( gl_FragCoord.xy ) * resolution*0.001,center)*influence*lightColor);

	gl_FragColor = vec4(vec3(color), 1.0);
}
