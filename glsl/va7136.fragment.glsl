#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

// Mental Mastery by logos7(@)o2.pl

// Using idea from Mental Mastery mandala on http://love2ascend.com/geometry/#MentalMastery
// Using http://logos7.pl/Anupadaka/sde_primitives3D.php for primitives
// Using http://logos7.pl/Anupadaka/sde_space_operations.php for space operations
// Using "Tron light cycle" heroku entry for SphereTracing (http://glsl.heroku.com/e#2953.6)
// Using dashxdr's rainbow heroku shader (http://glsl.heroku.com/e#7056.6)

// Not optimized!!!
// Not ideal - golden spiral constants needed!

float rainbow(float x)
{
	x=fract(0.16666 * abs(x));
	if(x>.5) x = 1.0-x;
	if(x<.16666) return 0.0;
	if(x<.33333) return 6.0 * x-1.0;
	return 1.0;
}

vec3 colorr(vec2 position)
 {
	float r = length(position);
	float a = atan(position.y, position.x);

	float b = a*12.0/3.14159;
	vec3 color = vec3(rainbow(b+2.0), rainbow(b+1.0), rainbow(b+0.0));

	float t = .5*(1.0 + cos(a + 10.0 * r * (1.0 + sin(a*20.0)*.1) - time*3.0) * (5.0 / (r+5.0)));

	return t * color;
}

vec3 rotateX(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = p.x;
    r.y = ca*p.y - sa*p.z;
    r.z = sa*p.y + ca*p.z;
    return r;
}

vec3 rotateY(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = ca*p.x + sa*p.z;
    r.y = p.y;
    r.z = -sa*p.x + ca*p.z;
    return r;
}

vec3 sopPolarRepeatY(vec3 P, float n)
{
	float r = length(P.xz);
	float a = atan(P.z, P.x);
	float c = 3.14159265358979 / n;

	a = mod(a, 2.0 * c) - c;
	
	P.x = r * cos(a);
	P.z = r * sin(a);

	return P;
}

vec3 sopPolarRepeatY2(vec3 P, float n)
{
	float r = length(P.xz);
	float a = atan(P.z, P.x);
	float c = 3.14159265358979 / n;

	a += c;
	a = mod(a, 2.0 * c) - c;

	P.x = r * cos(a);
	P.z = r * sin(a);

	return P;
}


float sdeCuboid(vec3 p, vec3 C, vec3 D)
{
	float f = 0.70710678;
	vec3 P = vec3(f * p.x + f * p.z, p.y, -f * p.x + f * p.z);
	
	vec3 K = abs(P - C) - 0.5 * D;
	return max(max(K.x, K.y), K.z);
}

float scene(vec3 p, out float m)
{

	vec3 P = p;
    	float d = 1e10;
	m = 0.0;

	vec3 O = sopPolarRepeatY(P, 12.0);
	vec3 O2 = sopPolarRepeatY2(P, 12.0);
	
	float A = sqrt(2.0);
	float S = 0.76;
	
	d = min(d, sdeCuboid(O, vec3(2.0, 0.5, -2.0), vec3(1.07, 1.0, 1.07)));
	d = min(d, sdeCuboid(O2, vec3(A, 0.5, -A), vec3(S, 1.2, S)));
	d = min(d, sdeCuboid(O, vec3(1.0, 0.5, -1.0), vec3(0.93*S * S, 1.5, 0.93*S * S)));
	d = min(d, sdeCuboid(O2, vec3(0.5 * A, 0.5, -0.5 * A), vec3(0.5*S, 2.1, 0.5*S)));
	d = min(d, sdeCuboid(O, vec3(0.5, 0.5, -0.5), vec3(0.35 * S, 3.0, 0.35 * S)));
	d = min(d, sdeCuboid(O2, vec3(0.25 * A, 0.5, -0.25 * A), vec3(0.244*S, 3.6, 0.244*S)));

	return d;
}

// calculate scene normal
vec3 sceneNormal(in vec3 pos )
{
    float eps = 0.0001;
    vec3 n;
    float m;
    float d = scene(pos, m);
    n.x = scene( vec3(pos.x+eps, pos.y, pos.z), m ) - d;
    n.y = scene( vec3(pos.x, pos.y+eps, pos.z), m  ) - d;
    n.z = scene( vec3(pos.x, pos.y, pos.z+eps), m ) - d;
    return normalize(n);
}

// ambient occlusion approximation
float ambientOcclusion(vec3 p, vec3 n)
{
    const int steps = 3;
    const float delta = 0.5;

    float a = 0.0;
    float weight = 1.0;
    float m;
    for(int i=1; i<=steps; i++) {
        float d = (float(i) / float(steps)) * delta; 
        a += weight*(d - scene(p + n*d, m));
        weight *= 0.5;
    }
    return clamp(1.0 - a, 0.0, 1.0);
}

// lighting
vec3 shade(vec3 pos, vec3 n, vec3 eyePos, float m)
{
    const vec3 lightPos = vec3(5.0, 10.0, 5.0);
    vec3 color = vec3(0.0, 0.5, 1.0);
    const float shininess = 100.0;

    color = mix(colorr(pos.xz), vec3(1.0), 0.74);
	
    vec3 l = normalize(lightPos - pos);
    vec3 v = normalize(eyePos - pos);
    vec3 h = normalize(v + l);
    float diff = dot(n, l);
    float spec = max(0.0, pow(dot(n, h), shininess)) * float(diff > 0.0);
    //diff = max(0.0, diff);
    diff = 0.5+0.5*diff;

    float fresnel = pow(1.0 - dot(n, v), 5.0);
    float ao = ambientOcclusion(pos, n);

    return vec3(diff*ao) * color + vec3(spec);
}

// trace ray using sphere tracing
vec3 trace(vec3 ro, vec3 rd, out bool hit, out float m)
{
    const int maxSteps = 128;
    const float hitThreshold = 0.001;
    hit = false;
    vec3 pos = ro;
    vec3 hitPos = ro;

    for(int i=0; i<maxSteps; i++)
    {
        float d = scene(pos, m);
        if (d < hitThreshold) {
            hit = true;
            hitPos = pos;
            //return pos;
        }
        pos += d*rd;
    }
    return hitPos;
}

vec3 background(vec3 rd)
{
     return mix(vec3(1.0), vec3(0.0, 0.5, 1.0), rd.y);
}

void main(void)
{
    vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    // compute ray origin and direction
    float asp = resolution.x / resolution.y;
    vec3 rd = normalize(vec3(asp*pixel.x, pixel.y, -2.0));
    vec3 ro = vec3(0.0, 0.0, 5.0);

    float roty = -(mouse.x-0.5)*2.0;
    float rotx = min(-0.4, (mouse.y-0.5)*6.0);

    rd = rotateX(rd, rotx);
    ro = rotateX(ro, rotx);
		
    rd = rotateY(rd, roty);
    ro = rotateY(ro, roty);
		
    // trace ray
    bool hit;
    float m = 0.0;
    vec3 pos = trace(ro, rd, hit, m);

    vec3 rgb;
    if(hit)
    {
        // calc normal
        vec3 n = sceneNormal(pos);
        // shade
        rgb = shade(pos, n, ro, m);

     } else {
        rgb = background(rd);
     }

    // vignetting
    rgb *= 0.5+0.5*smoothstep(2.0, 0.5, dot(pixel, pixel));

    gl_FragColor=vec4(rgb, 1.0);
}