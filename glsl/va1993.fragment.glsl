// Hi anon person again - nice mod! (I fixed one little thing)
// Enjoy this little (second!) branchless version of your idea!
// Greetings las/mercury

// Posted by las
// http://www.pouet.net/topic.php?which=7920&page=29&x=14&y=9

// Low-end mod



#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi 3.14159265
#define R(p, a) p=cos(a)*p+sin(a)*vec2(p.y, -p.x)
#define hsv(h,s,v) mix(vec3(1.), clamp((abs(fract(h+vec3(3., 2., 1.)/3.)*6.-3.)-1.), 0., 1.), s)*v

float pn(vec3 p) {
   vec3 i = floor(p);
   vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
   vec3 f = cos((p-i)*pi)*(-.5) + .5;
   a = mix(sin(cos(a)*a), sin(cos(1.9+a)*(1.+a)), f.x);
   a.xy = mix(a.xz, a.yw, f.y);
   return mix(a.x, a.y, f.z);
}

float fpn(vec3 p) {
   return pn(p*.06125)*.5 + pn(p*.125)*.25 + pn(p*.25)*.125;
}

vec3 n4 = vec3(0.577,0.577,0.577);
vec3 n10 = vec3(0.934,0.000,0.357);
vec3 n18 = vec3(0.851,0.526,0.000);

float spikeball(vec3 p) {
#ifdef OLD
	vec3 q=p;
	p = normalize(p);
	p = abs(p);
	//p = p.x > p.y && p.x > p.z ? p : p.y > p.z ? p.yzx : p.zxy;
	//p = (p.x > p.y && p.x > p.z) ? p : (p.y > p.z ? p.yzx : p.zxy);
	// las opt. iteration 1.
	//p = (p.x > p.y && p.x > p.z) ? p : mix(p.zxy, p.yzx, step(p.z, p.y));
	// las opt. iteration 2:
	p = mix(mix(p.zxy, p.yzx, step(p.z, p.y)), p, step(p.y, p.x) * step(p.z, p.x));
	float b = pow(max(dot(p,n4),max(dot(p,n10),dot(p,n18))), 140.);
	return length(q)-2.5*pow(1.5,b*(1.-mix(.3, 1., sin(time*2.)*.5+.5)*b));
#else
	// This is what I more or less recommend to use (TOP SECRET CODE FROM MERCURY - USE WITH CAUTION)
	float l = length(p);
	p = abs(normalize(p));
	p = mix(mix(p.zxy, p.yzx, step(p.z, p.y)), p, step(p.y, p.x) * step(p.z, p.x));
	float b = max(
		max(dot(p,vec3(.577)),
			dot(p.xz,vec2(.526,.851))), // <--- seems to be necessary (try specular reflections without it)
		max(dot(p.xz,vec2(.934,.357)),
			dot(p.xy,vec2(.851,.526))));
	// Three lines full of magic to play with:
	b = acos(b-0.01) / (3.1415*.5);
	b = smoothstep(.2, 0.0, b);
	return l - 2.0 - b * .7;
	// las/mercury - END OF TRANSMISSION - <3
#endif
}

float f(vec3 p) {
   p.z += 6.;
#ifdef OLD
   R(p.xy, time);
   R(p.xz, time);
#else
   R(p.yz, .5 * time);
   R(p.xz, .5 * time + p.x * sin(time * acos(-1.)) * .2);	
#endif
   return spikeball(p);
}

vec3 g(vec3 p) {
   vec2 e = vec2(.0001, .0);
   return normalize(vec3(f(p+e.xyy) - f(p-e.xyy),f(p+e.yxy) - f(p-e.yxy),f(p+e.yyx) - f(p-e.yyx)));
}


void main(void)
{  
   // p: position on the ray
   // d: direction of the ray
   vec3 p = vec3(0.,0.,2.);
   vec3 d = vec3((gl_FragCoord.xy/(0.5*resolution)-1.)*vec2(resolution.x/resolution.y,1.0), 0.) - p;
   d = normalize(d); 
   
   // ld, td: local, total density 
   // w: weighting factor
   float ld, td= 0.;
   float w;
   
   // total color
   vec3 tc = vec3(0.);
   
   // i: 0 <= i <= 1.
   // r: length of the ray
   // l: distance function
   float i, r, l, b=0.;

   // rm loop
   for (int i2=0; i2 < 32; i2++) {
	float i = float(i2)/64.;
	//   if(!((i<1.) && (l>=0.001*r) && (r < 50.)&& (td < .95)))
	//	   break;
      // evaluate distance function
      l = f(p) * 0.5;
      
      // check whether we are close enough
      //if (l < .05) {
        // compute local density and weighting factor 
        ld = 0.05 - l;
        w = (1. - td) * ld;   
        
        // accumulate color and density
        tc += w; //* hsv(w, 1., 1.); 
        td += w;
      //}
      td += 1./200.;
      
      // enforce minimum stepsize
      l = max(l, 0.03);
      
      // step forward
      p += l*d;
      r += l;
   }     
      
   gl_FragColor = vec4(1.+td*.009, ld, 1.+tc.r*.009, 1.0);
}