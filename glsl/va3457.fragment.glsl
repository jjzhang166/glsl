#ifdef GL_ES 
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//setup 2012, George Toledo, comments below by OG author. I stripped out the vert shader origin dependency etc., and other fixes for WebGL-gtoledo
// FragmentProgram
// based on iq/rgba 's seminar 
// "Rendering Worlds with Two Triangles with raytracing on the GPU in 4096 bytes"
// at NVSCENE 08
// I have watched this great seminar, I have coded the below test program. ;)
// [http://www.rgba.org/iq/]

//varying vec3 dir;


vec3	org=vec3(6.*cos(time*.2),0.2*cos(time),5.*sin(time*.2));//animating the origin-gt
//vec3	dir=normalize(vec3(1.,1.,1.));
vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    // compute ray origin and direction
    float asp = resolution.x / resolution.y;
    vec3 dir = normalize(vec3(asp*pixel.x, pixel.y, 2.0));
 //   vec3 dir = vec3(0.0, 0.0, 4.0);
    
    
float flr(vec3 p, float f)
{
	return abs(f - p.y);
}

float sph(vec3 p, vec4 spr)
{
	return length(spr.xyz-p) - spr.w;
}

float cly(vec3 p, vec4 cld)
{
	return length(vec2(cld.x + 0.5 * sin(p.y + p.z * 2.0), cld.z) - p.xz) - cld.w;
}

float scene(vec3 p)
{
	float d = flr(p, -5.0);
	d = min(d, flr(p, 5.0));
	d = min(d, sph(p, vec4( 1.9,-2.*sin(time), 12.*cos(time)+15., 1.5)));
	d = min(d, sph(p, vec4(-8., 0.5*cos(time), 20., 2.0)));
	d = min(d, sph(p, vec4(-5., 4.*sin(time), 15.*sin(time)+15., 0.5)));
	d = min(d, sph(p, vec4(-1., 3.*cos(time), 15., 2.0)));
	d = min(d, sph(p, vec4( 2.,-3., 15., 0.5)));
	d = min(d, cly(p, vec4(12., 0., 30., 1.25)));
	d = min(d, cly(p, vec4( 4., 0., 15., 1.0)));
	d = min(d, cly(p, vec4( 0., 0., 20., 1.0)));
	d = min(d, cly(p, vec4(-2., 0., 25., 1.0)));
	d = min(d, cly(p, vec4(-6., 0., 30., 1.0)));
	d = min(d, cly(p, vec4(-16.,0., 40., 2.0)));
	return d;
}

vec3 getN(vec3 p)
{
	float eps = 0.01;
	return normalize(vec3(
		scene(p+vec3(eps,0.,0.))-scene(p-vec3(eps,0.,0.)),
		scene(p+vec3(0.,eps,0.))-scene(p-vec3(0.,eps,0.)),
		scene(p+vec3(0.,0.,eps))-scene(p-vec3(0.,0.,eps))
	));
}

float AO(vec3 p,vec3 n)
{
	float dlt = 0.5;
	float oc = 0.0, d = 1.0;
	for(int i = 0; i < 6; i++)
	{
		oc += (float(i) * dlt - scene(p + n * float(i) * dlt)) / d;
		d *= 2.0;
	}
	return 1.0 - oc;
}

void main()
{
	float g,d = 0.0;
	vec3 p = org;
	for(int i = 0; i < 64; i++)
	{
		d = scene(p);
		p = p + d * dir;
	}
	if(d > 1.0)
	{
		gl_FragColor = vec4(0,0,0,1);
		return;
	}
	vec3 n = getN(p);
	float a = AO(p,n);
	vec3 s = vec3(0.,0.,0.);
	vec3 lp[3],lc[3];
	lp[0] = vec3(-4.,0.,4.);
	lp[1] = vec3(2.,3.,8.);
	lp[2] = vec3(4.,-2.,24.);
	lc[0] = vec3(1.0,0.75,0.4);
	lc[1] = vec3(0.7,0.2,0.0);
	lc[2] = vec3(0.25,0.5,1.0);
	for(int i = 0; i < 3; i++)
	{
		vec3 l,lv;
		lv = lp[i] - p;
		l = normalize(lv);
		g = length(lv);
		g = max(0.0,dot(l,n)) / g * float(10.);
		s += g * lc[i];
	}
	float fg = min(1.0,40.0 / length(p - org));
	gl_FragColor = vec4(s * a,1.) * fg * fg;
}
