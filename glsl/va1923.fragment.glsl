#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//uniform float distortFactor, sphereRadius, perspective, threshold, maxIters, lightStrength, ambient, time, maxD;
//uniform vec3 block1p, block1s, camCoords, lightPos;
//uniform vec4 cube1, cube4, sphere1, sphere2, sphere3;

//varying vec3 v,EP;

#define R(p,a) p=cos(a)*p+sin(a)*vec2(-p.y,p.x);
#define pi 3.141592653589793
#define maxD 10.
#define maxIters 100.
#define ambient 0.1;

float threshold = 0.001;
vec3 lightPos = vec3(1.);

float cube(vec4 cube, vec3 pos){
	cube.xyz -= pos;
	return max(max(abs(cube.x)-cube.w,abs(cube.y)-cube.w),abs(cube.z)-cube.w);
}

float block(vec3 s, vec3 c, vec3 pos){
	c -= pos;
	return max(
		max(
			abs(c.x)-s.x,
			abs(c.y)-s.y
		),
		abs(c.z)-s.z
	);
}

float tracePlane(vec3 p, vec3 d){
	return sign(p.y) + sign(d.y) == 0. ? length(d* p.y / d.y): maxD;
}

float plane(vec3 p){
	return p.y;
	//return p.z * (p.y + 0.2);
}

float cblock(float seed, float count, vec3 p){ // creates city block. Expects p in 0..1 range. count = no. of towers

	float d = maxD; // distance
	float d2 = maxD;
	vec3 op = p; // original p
	vec3 s, c;
	float maxC = count;
	for(float count=6.; count > 0.; count--){
		
		s = vec3(
			sin(count * seed * 55.),
			sin(count * seed * 34.),
			sin(count * seed)
		);
		s = (s * 0.15) + 0.18;
		s.y *= 3.;
		s = max(s, 0.2);
		
		c = vec3(
			sin(count * seed),
			s.y*1.,
			sin(count * seed)
		);
		c.xz = (c.xz * 0.5) + 0.5;
		c.xz = clamp(s.xz, s.xz + 0.1, 0.9 - s.xz);
		
		// rooftop
		vec3 s2 = s;
		s2.y = 0.1;
		vec3 c2 = c;
		c2.y *= 2.;
		d2 = min(
			d,
			min(
				max(
					block(s, c, p),
					-cube(vec4(0.1, 0.1, 0.1, 0.04), mod(p, 0.2))
				),
				block(s2, c2, p)
			)
		);
		//d = min(d, block(s, c, p));
		d = mix(d, d2, .92);
	}
	
	return d;
}

float distFunction(vec3 p){
	vec3 op = p;
	p = mod(p, vec3(1., 0., 1.));
	return cblock(sin(floor(op.x +55.)) + cos(floor(op.z + 34.)), 5., p);
}

float ft(vec3 p){
	return cube(vec4(.5,.5,.5,.2), mod(p, vec3(1., 0., 1.0)));
}

vec2 rm(vec3 pos, vec3 dir, float threshold, float maxSteps, float td){
	vec3 startPos = pos;
	float l;
	l = 0.;
	l = min(tracePlane(pos + vec3(0., -1.5, 0.), dir), 0.);
	pos += dir * l;
	for(float i=0.; i<=1.; i+=1.0/maxIters){
		l = distFunction(pos);
		if(l < threshold){
			break;
		}
		if(i == 1.){
			l = maxD;
			break;
		}
		pos += (l * dir * .1);// + threshold;
		//dir.xy += i * 0.02;
	}
	l = length(startPos - pos);
	return vec2(l < td ? 1.0 : -1.0, min(l, td));
}

// pos = point on surface, l = light position, r = shadow softness factor, f = shadow strength, i = step count 
/*
float softShadow(vec3 pos, vec3 l, float r, float f, float i, float td) {
	float d;
	vec3 p;
	float o = 1.0, maxI = i, or = r;
	float len;
	for (; i>1.; i--) {
		len = (i - 1.) / maxI;
		//len *= 0.5; // smaller sharper shadows
		p = pos + ((l - pos) * len);
		r = or * len;
		d= clamp(
			distFunction(p), 0.0, 1.0
		);
		//d = f(p);
		o -= d < r ? (r -d)/(r * f) : 0.;
		
		if(o < 0.) break;
	}
	return o;
}
*/

/*
float ao(vec3 p, vec3 n, float d, float i) {
	float o;
	for (o=1.;i>0.;i--) {
		o-=(i*d-abs(distFunction(p+n*i*d)))/pow(2.,i);
	}
	return o;
}
*/

void main()
{

	//vec3 camPos = EP;     //set ray origin
	vec3 camPos = vec3(0., 3., 0.);
	//vec3 rayDir = v-camPos;   //set ray direction
	vec3 rayDir = vec3(0., 0., 1.);
	rayDir = normalize(rayDir);
	
	float camDist = length(camPos);
	
	float gd = tracePlane(camPos, rayDir);
	vec2 march = rm(camPos, rayDir, threshold, maxIters, gd);
	
	//float e = 0.01;//0.001;
	
	vec3 point = camPos + (rayDir * march.g);
	
	vec2 e = vec2(0.0001, 0.0);
	vec3 n = march.x == 1.0 ? 
		(vec3(distFunction(point+e.xyy),distFunction(point +e.yxy),distFunction(point +e.yyx))-distFunction(point))/e.x :
		vec3(0., 1., 0.);
		
	vec3 lightDir = normalize(lightPos);
	//float lightDist = length(lightPos - point);
	//lightDir = normalize(lightDir);
	float intensity = max(dot(n, lightDir), 0.0) * 0.5;
	vec3 lightPos2 = point + lightDir;//vec3(.5, 0.5, -.5);
	//intensity *= 2.*softShadow(point, point + lightPos, 0.4, 16., 20., gd)-.5; // soft shadow
	//intensity *= 0.5;
	
	vec3 aol = vec3(0., 0.5, 0.);
	//intensity *= softShadow(point, point + (n * 2.), 2.0, 6., 5., gd)-.5; // AO
	//intensity *= ao(point, n, .5, 10.);
	
	intensity += ambient; // ambient
	intensity -= exp(march.y)*0.00002;
	intensity = march.y == maxD ? 0. : intensity;
	vec4 p = vec4(1.0);
	vec3 c = march.x == -1. ? vec3(sin(point)) * .25 : vec3(1.);
	c += 0.75;
	p.rgb = vec3(c * intensity);
	p.rgb = vec3(1.);
	//p.rgb = n;
//	p.a = march.x == -1.0 ? 0.0 : 1.0;
	gl_FragColor = p;
}
