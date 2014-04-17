// The Flaming Onion Ring!
// Not nearly as hot as what las posted on http://glsl.heroku.com/e#1802.0
// http://www.pouet.net/topic.php?which=7920&page=29&x=14&y=9

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
   a = mix(sin(cos(a)*a), sin(cos(1.+a)*(1.+a)), f.x);
   a.xy = mix(a.xz, a.yw, f.y);
   return mix(a.x, a.y, f.z);
}

float fpn(vec3 p) {
   return pn(p*.06125)*.5 + pn(p*.125)*.25 + pn(p*.25)*.125;
}


float flamingOnionRing(vec3 p) {
  vec2 q = vec2(length(p.xy)-2.0,p.z);
  return length(q)-1.0+sin(time);
}

float f(vec3 p) {
   p.z += 6.;
   R(p.yz, -mouse.y*pi*2.);
   R(p.xz, mouse.x*pi*2.);
   return flamingOnionRing(p) +  fpn(p*50.+time*25.) * 0.45;
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
   for (float i=0.; (i<1.); i+=1./64.) {
	   if(!((i<1.) && (l>=0.001*r) && (r < 50.)&& (td < .95)))
		   break;
      // evaluate distance function
      l = f(p) * 0.5;
      
      // check whether we are close enough
      if (l < .05) {
        // compute local density and weighting factor 
        ld = 0.05 - l;
        w = (1. - td) * ld;   
        
        // accumulate color and density
        tc += w * hsv(w, 1., 1.); 
        td += w;
      }
      td += 1./200.;
      
      // enforce minimum stepsize
      l = max(l, 0.03);
      
      // step forward
      p += l*d;
      r += l;
   }     
      
   gl_FragColor = vec4(tc, 1.0);
}