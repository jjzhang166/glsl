#ifdef GL_ES
precision highp float;
#endif

const float PI = 3.1415926535897932384626433832795;

// @rianflo - work in progress...
// in search for some cheap orthofake3d backdrop
//

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 rotateX(in vec3 v, in float angle)
{
	vec3 res;
	float C = cos(angle);
	float S = sin(angle);
	res.y = v.y * C - v.z * S;
	res.z = v.y * S + v.z * C;
	return res;
}

// Noise functions...
float Hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

//--------------------------------------------------------------------------
float Hash(vec2 p)
{
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

//--------------------------------------------------------------------------
float Noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( Hash(n+  0.0), Hash(n+  1.0),f.x),
                    mix( Hash(n+ 57.0), Hash(n+ 58.0),f.x),f.y);
    return res;
}

//--------------------------------------------------------------------------
vec2 Noise2( in vec2 x )
{
	vec2 res = vec2(Noise(x), Noise(x+vec2(4101.03, 2310.0)));
    return res-vec2(.5, .5);
}

//--------------------------------------------------------------------------
// iq's derivative noise function...
vec3 NoiseDerivative( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    vec2 u = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float a = Hash(n+  0.0);
    float b = Hash(n+  1.0);
    float c = Hash(n+ 57.0);
    float d = Hash(n+ 58.0);
	return vec3(a+(b-a)*u.x+(c-a)*u.y+(a-b-c+d)*u.x*u.y,
				30.0*f*f*(f*(f-2.0)+1.0)*(vec2(b-a,c-a)+(a-b-c+d)*u.yx));
}

vec3 terrain(vec2 p)
{
	vec3 ret = vec3(p.y-1.2, 0.0, 0.0);
	float f = 0.25;
	float s = 1.5;
	
	for (int i=0; i<7; i++)
	{
		ret += NoiseDerivative(p*f) * s;
		f *= 2.0;
		s *= 0.5;
	}
	return ret;
}

void main( void ) 
{
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);
	vec2 sp = p;
	m.x += 0.5*time;
	p.x += 0.5*time;

	// the stuff
	vec2 sunP = vec2(0.8, m.y*PI);
	float sunSD = distance(sunP, sp) - 0.3; 
	vec3 sd = terrain(p);
	float terrainSD = (sd.x-0.2*sd.y);
	vec3 normal = normalize(vec3(sd.yz, -sd.x));

	// the light
	vec3 sunV = rotateX(vec3(0.0, 0.0, -1.0), m.y*PI);	
	vec3 c = vec3((sd.yz + 1.0)*0.5, length(sd.yz));
	float i = max(0.0, dot(normal, sunV));

	
	if (terrainSD < 0.0)
	{
		gl_FragColor = vec4(vec3(0.2, 0.2, 0.4)+i, 1.0);
	}
	else if (sunSD < 0.0)
	{
		gl_FragColor = vec4(0.7, 0.7, 0.9, 1.0) + smoothstep(0.0, 0.5, -sunSD*2.0);
	}
	else 
	{
		gl_FragColor=vec4(0.7, 0.7, 0.9, 1.0);
	}
	
}