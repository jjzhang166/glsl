#ifdef GL_ES
precision highp float;
#endif

uniform float t;
uniform vec2 wh;

#define time t
#define EPSILON 0.0001
#define R(p, a) p=cos((a))*p+sin((a))*vec2(p.y, -p.x)

float fbox(vec3 p, vec3 s) {
   vec3 d = abs(p) - s;
   float m = max(d.x,max(d.y, d.z));
   return mix(m, length(max(d, 0.0)),step(0.,m));
}

float fblobb(vec3 p){
	R(p.yz, .5 * time);
	R(p.xz, .5 * time + p.x * sin(time * acos(-1.)) * .2);
	float l = length(p);
	p = abs(normalize(p));
	p = mix(mix(p.zxy, p.yzx, step(p.z, p.y)), p, step(p.y, p.x) * step(p.z, p.x));
	float b = max(
		max(dot(p,vec3(.577)),
			dot(p.xz,vec2(.934,.357))),
		max(dot(p.yx,vec2(.526,.851)),
			dot(p.xz,vec2(.526,.851))));
	b = acos(b-0.01) / (3.1415*.5);
	b = smoothstep(.2, 0.0, b);
	return l - 1.5 - b * .75;
}

float fblob(vec3 p){
	//R(p.yz, .5 * time);
	float dt = time*0.25;
	float t = dt*2. + p.y * (-0.1+.5*(cos(1.*dt*acos(-1.))*.5+0.5));
	R(p.xz, t);
		
	float d = fbox(p, vec3(1.88)) - .75;
	d = max(d, -fblobb(p));

	return d;
}

float f0(vec3 p) {
	float d = dot(p - vec3(0., -5., 0.), vec3(0., 1., 0.));
	d = min(d, -length(p) + 150.);
	d = min(d, length(p - vec3(3., 0., 0.) - 1.));
	return min(d, fbox(p - vec3(0., 0., 0.), vec3(1.)));
}

float f1(vec3 p) {
	return f0(p);
}

vec2 sphere(vec3 p, vec3 d, vec4 c) {
	vec3 l = c.xyz - p;
	float s = dot(l, d);
	float ll = dot(l, l);
	if (s < 0. && ll > c.w)
		return vec2(0.);
	
	float mm = ll - s * s;
	if (mm > c.w)
		return vec2(0.);   
	
	float u = sign(ll - c.w);
	return vec2(EPSILON * step(mm, c.w) * u, s - sqrt(c.w - mm) * u);
}

vec2 plane(vec3 p, vec3 d, vec4 c) {
	float v = -dot(d,c.xyz);
	float t = (dot(p, c.xyz) - c.w) / v;
	return vec2(EPSILON * sign(v) * step(0., t), t); 
}

vec2 box(vec3 p, vec3 d, vec3 c, vec3 s) {
	vec3 bl = c - s, bh = c + s;
	vec3 ol = (bl - p) / d, oh = (bh - p) / d;
	vec3 l = min(ol, oh);
	vec3 h = max(ol, oh);
	float ff = min(h.x, min(h.y, h.z));
	float fn = max(max(l.x, 0.), max(l.y, l.z));
	vec3 sl = step(bl, p);
	vec3 sh = step(p, bh);
	float u = step(3., dot(sl, sh));
	return vec2(EPSILON * (u*-2.+1.) * step(fn, ff), mix(fn, ff, u));
} 

vec2 rm(vec3 p, vec3 d) {
	vec2 h = box(p, d, vec3(0.), vec3(3.5));
	//vec2 h = sphere(p, d, vec4(0,0,0,2.5*2.5));
	vec3 q = p;
	
	if (h.x == 0.)
		return h;
		
	if(h.x > 0.)
		p += d * h.y;
				
	h.x = sign(fblob(p));
	d *= h.x;
	
	float r = 0., l = 0., i;	
	//for (i = 0.; i < 1.; i += 1./80.){
	for (int j = 0; j < 80; ++j) {
		i = float(j)/80.;
		l = fblob(p);
		p += l * d * .5;
		l = abs(l);
		r += l;
		if (l < r * .01) break;
	}
	
	if (i >= 1.)
		return vec2(0.);
	
	h.x *= l;
	h.y = length(q - p);
	return h;
}

vec3 intersection(vec3 p, vec3 d) {
	vec2 t;
	vec3 h = vec3(0., 500., -1.);
	
	t = plane(p, d, vec4(0., 1., 0., -5.));
	h = mix(h, vec3(t, 0.), abs(sign(t.x)) * step(t.y, h.y) * step(0., t.y));
	
	t = sphere(p, d, vec4(0., 0., 0., 150.*150.));
	t.x *= -1.;
	h = mix(h, vec3(t, 1.), abs(sign(t.x)) * step(t.y, h.y) * step(0., t.y));

	t = rm(p, d);
	h = mix(h, vec3(t, 2.), abs(sign(t.x)) * step(t.y, h.y) * step(0., t.y));
	
	return h;
}

float ambient(vec3 p, vec3 n, float d) {
	float s = sign(d);
	float o = s*.5+.5;
	for (float i = 6.0; i > 0.; --i) {
		o -= (i*d - f0(p+n*i*d*s)) / exp2(i);
	}
	return o;
}

vec4 info(inout vec3 p, vec3 d, vec3 h, out vec3 n, out bvec2 f) {
	vec4 c = vec4(0.);
	n = vec3(0.);
	f = bvec2(false, false);
	p += d * h.y;

	vec3 l = normalize(vec3(0, 35, 0) +
		10. * vec3(cos(time*2.), 0, sin(time*2.)) - p);

	if (h.z == 0.) {
		f = bvec2(false, false);
		n = vec3(0, 1, 0);
		c = .5 * vec4(1, 1, 1, 1);
		c *= max(dot(n,l), 0.);
		c += 0.2;
		c *= ambient(p, l, 0.3);
	} else if (h.z == 1.) {
		f = bvec2(false, false);
		n = -normalize(p);
		c = .5 * vec4(1.);
		c *= max(dot(n,l), 0.);
		c *= ambient(p, l, 0.3);
	} else if (h.z == 2.) {
		f = bvec2(true, true);
		vec2 e = vec2(.1, .0);
		n = normalize(
			vec3(
				fblob(p+e.xyy) - fblob(p-e.xyy),
				fblob(p+e.yxy) - fblob(p-e.yxy),
				fblob(p+e.yyx) - fblob(p-e.yyx)
				)
		);
		
		//c = vec4(n * .5 + .5, .5);
		c = vec4(0.4, 0.3, 0.7, 1);
		c *= 0.5 * max(dot(n,l), 0.);
		// Phong
		float ph = pow(max(dot(reflect(l, n), d), 0.), 64.);
		c += 0.8*smoothstep(0.6, .8, ph);//sin(acos(-1.)*ph*0.5)*.5+.5);
	
		// Blinn
		//c += pow(max(abs(dot(n,normalize(l - d))), 0), 32.);
	}
	
	return c;
}

#define R0 0.0
#define ETA 1.08

float fresnel(vec3 d, vec3 n) {
	return  R0 + (1. - R0) * pow(1. - abs(dot(n, d)), 4.);
}

void main() {
	vec3 p = vec3(0.,0.,0.51337);
		//p.yz += vec2(10.);
	vec3 d = vec3((gl_FragCoord.xy/(0.5*wh)-1.)*vec2(wh.x/wh.y,1.0), 0.)-p;
#define r wh
	//mat4 M=mat4(MT[0]., MT[1], MT[2], MT[3]);
	//vec2 vp=(gl_FragCoord.xy/r)*2.-1.;
	//vec3 dv=(M*vec4(vec3(vp.x*r.x/r.y,vp.y,-1./tan((3.1415*45./180.)*0.5)),0.)).xyz;
	//vec3 p=(M*vec4(0.,0.,0.,1.)).xyz;
	d=normalize(d);
			p.yz += vec2(.5,5.1337);
	//R(p.xz, t);
	//R(d.xz, -t);


	
	vec3 h = intersection(p, d);
	
	if (h.x==0.) {
		gl_FragColor = vec4(1, 1, 1, 1);
		return;
	}

	vec3 n;
	bvec2 f;
	vec4 c = info(p, d, h, n, f);
	vec4 a = mix(
		exp(-h.y *  vec4(2,0.5,0.3,1)),
		vec4(1), (sign(h.x) * .5 + .5)
	);

	vec3 p0 = p, d0 = d, h0 = h, n0 = n;
	bvec2 f0 = f;
	
	float r = 1.;
	for (int i = 0; i < 3; ++i) {
		if (!f.x) break;
		r *= fresnel(d, n);
		d = reflect(d, n);

		p += n * h.x;
		h = intersection(p, d);
		if (h.x == 0.0) break;
		c += info(p, d, h, n, f) * r;
	}

	f = f0, n = n0, h = h0, d = d0, p = p0;
	r = 1.;
	for (int j = 0; j < 8; ++j) {
		if (!f.y) break;
	vec3 dt = d;
		a *= 1.- fresnel(d, n);
		d = refract(d, n * sign(h.x), mix(ETA/1.0, 1.0/ETA, sign(h.x) * .5 + .5));
		if (dot(d,d) == 0.) {
			d = reflect(dt, n);
			h.x *= -1.;
		}

		p -= n * h.x;
		h = intersection(p, d);
		if (h.x == 0.0) break;
		
		a *= mix(exp(-h.y * 1. *vec4(0.5,0.65,0.1,1)),
			vec4(1), sign(h.x) * .5 + .5);	
		c += info(p, d, h, n, f) * a;
	}
	
	gl_FragColor = vec4(c.xyz, 1.);
	//if (isnan(dot(o0, o0))) o0 = vec4(1,0,0,1);
	

	//gl_FragColor.xyzw = vec4(.5, .5, .5, 1.);

}