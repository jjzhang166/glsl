// figuring out how to write a raytracer
// @psovodomrd


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define INF 1000.

float
box(vec3 p, vec3 d, vec3 bp, vec3 bd, out vec3 n)
{
	vec3 a = -(p - bp + bd)/d;
	vec3 b = -(p - bp - bd)/d;
	float k = INF;

	n = vec3(0);
	if(a.x > 0. && a.x < k){ k = a.x; n = vec3(1,0,0); }
	if(b.x > 0. && b.x < k){ k = b.x; n = vec3(-1,0,0); }
	if(a.y > 0. && a.y < k){ k = a.y; n = vec3(0,1,0); }
	if(b.y > 0. && b.y < k){ k = b.y; n = vec3(0,-1,0); }
	if(a.z > 0. && a.z < k){ k = a.z; n = vec3(0,0,1); }
	if(b.z > 0. && b.z < k){ k = b.z; n = vec3(0,0,-1); }
	return k;
}

int
intersect(vec3 ro, vec3 rd, out vec3 outn, out float outk)
{
	int obj = 0;
	outk = INF;
	outn = vec3(1);
	
	// intersection with plane
	vec3 tmpn;
	float k = box(ro, rd, vec3(0), vec3(5), tmpn);
	if(k < outk){
		obj = 1;
		outk = k;
		outn = tmpn;
	}	
	
	
	// intersection with sphere
	vec3 so = vec3(0,2.+sin(time*1.2),0);
	float sr = 1.;
	vec3 sro = ro - so;
	float a = dot(rd, rd);
	float b = 2.*dot(sro, rd);
	float c = dot(sro, sro) - sr*sr;	
	float D = b*b - 4.*a*c;
	if(D > 0.){
		float k = (-b - sqrt(D))/(2.*a);
		if(k > 0. && k < outk){
			obj = 2;
			outk = k;
			outn = normalize(sro + k*rd);
		}
	}
	
	return obj;
}

vec3
checker(float x, float y, float z, vec3 c1, vec3 c2)
{
	if(mod(100.+floor(x+.001) + floor(y+.001) + floor(z+.001), 2.) < 1.)
		return c1;
	return c2;
}


vec3
light(vec3 co, vec3 xo, vec3 xn, int obj, vec3 c)
{
	vec3 lo = vec3(sin(time)*2., 2.4, cos(time)*2.);
	vec3 xld = normalize(lo - xo);
	vec3 xcd = normalize(co - xo); 
	vec3 unus;
	float k;
	float spec, amb, diff;
	
	amb = .1;
	spec = 0.;
	diff = 0.;
	
	intersect(xo+.01*xn, xld, unus, k);
	float d = length(lo - xo);
	if(k >= d){
		diff = clamp(dot(xld, xn), 0., 1.)/(.5 + .2*d + .2*d*d);
		if(obj == 2){			
			if(dot(xcd, reflect(-xld, xn)) > cos(6.2831/360.*10.)){
			//	return vec3(1,0,0);
			}
			//spec = pow(clamp(dot(co, reflect(xld, xn)), 0., 1.), 1.);
			spec = pow(clamp(dot(-xcd, reflect(xld, xn)), 0., 1.), 32.);
		}
	}
	
	c = spec + c*(amb + diff);
	return c;
}


void
main(void)
{
	vec2 p = (2.*gl_FragCoord.xy - resolution.xy) / resolution.y;
	vec3 xc;
	float c;
	vec3 xn, xo;
	float k;
	float l;
	
	vec3 ro = vec3(0,2,-3);
	vec3 rd = normalize(vec3(p.xy, 1));
	int obj = intersect(ro, rd, xn, k);
	
	//vec3 t1, t2;
	//obj = intersect(ro + k*rd + xn*.1, vec3(0,1,0), t1, k);
	
	xo = ro + k*rd;
	if(obj == 2){
		//vec3 xs = normalize(xo - vec3(0,1,0));
		vec3 xs = xn;
		float a = atan(xs.z, xs.x)/6.2831;
		float b = atan(sqrt(dot(xs.xz, xs.xz)), xs.y)/6.2831;
		//xc = checker(a*30., b*30., 0., vec3(.5,1,1), vec3(.8,1,1));
		xc = vec3(1,.7,.7);
	}else if(obj == 1){
		xc = checker(xo.x, xo.y, xo.z, vec3(.1,.1,.1), vec3(.7,.7,.7));
	}else{
		xc = vec3(1,1,0);
	}
	xc = light(ro, xo, xn, obj, xc);

	gl_FragColor = vec4(xc,1.);
}