// The Flaming Onion Ring!
// Not nearly as hot as what las posted on http://glsl.heroku.com/e#1802.0
// http://www.pouet.net/topic.php?which=7920&page=29&x=14&y=9

// Black hole added by Kabuto 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi 3.14159265
#define R(p, a) p=cos(a)*p+sin(a)*vec2(p.y, -p.x)
#define hsv(h,s,v) mix(vec3(1.), clamp((abs(fract(h+vec3(3., 2., 1.)/3.)*6.-3.)-1.), 0., 1.), s)*v
const float mass = .5; // mass (and radius of the event horizon as well)

float pn(vec3 p) {
   vec3 i = floor(p);
   vec4 a = dot(i, vec3(10., 47., 5.)) + vec4(0., 57., 21., 78.);
   vec3 f = cos((p-i)*pi)*(-.5) + .5;
   a = mix(sin(cos(a)*a), sin(cos(1.+a)*(1.+a)), f.x);
   a.xy = mix(a.xz, a.yw, f.y);
   return mix(a.x, a.y, f.z);
}

float fpn(vec3 p) {
   return pn(p*.06125)*.90 + pn(p*.125)*.25 + pn(p*.25)*.125;
}


float flamingOnionRing(vec3 p) {
  vec2 q = vec2(length(p.xy)-2.0,p.z);
  return length(q)-.5;
}

float f(vec3 p) {
   return flamingOnionRing(p) +  fpn(p*50.+time*25.) * 0.47;
}
/*
vec3 g(vec3 p) {
   vec2 e = vec2(.0001, .0);
   return normalize(vec3(f(p+e.xyy) - f(p-e.xyy),f(p+e.yxy) - f(p-e.yxy),f(p+e.yyx) - f(p-e.yyx)));
}*/


void main(void)
{  
   // p: position on the ray
   // d: direction of the ray
	vec2 d2 = (gl_FragCoord.xy/(0.5*resolution)-1.)*vec2(resolution.x/resolution.y,1.0);
   vec3 d = vec3(2.,d2.x,d2.y);
   d = normalize(d); 
	//float 
	float t2 = time*.23;
	float t = t2 + sin(t2)*.9;
   vec3 p = vec3(0., 3.21+cos(t)*2.7,sin(t)*1.7);
p.xy = p.y*vec2(cos(time),sin(time));
	//R(p.xy,time);
   //R(p.yz, -mouse.y*pi*2.);
   R(d.xz, sin(t2)*.5-(mouse.y-.5)*.9);
   //R(p.xz, mouse.x*pi*2.);
   R(d.xy, cos(t2 - sin(t2)*.5)*1.5+1.5-(mouse.x-.5)*resolution.x/resolution.y*.9);
R(d.xy, -time);

	
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
	   if(!((i<1.) && (l>=0.001*r) && (r < 50.)&& (td < .95)) || dot(p,p) < mass*mass)
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
      
      l = max(l, 0.03);
	l = min(l, (length(p)-mass)*.5);
      l = max(l, 0.001);
	   
      // enforce minimum stepsize
	   //a
	
	   
      
      // step forward
      p += l*d;
      r += l;
	// Approximated event horizon. I don't know the relativistic field equations inside out but I've derived this here using approximations and the result looks fine.
	vec3 fieldDeriv = p * mass / pow(length(p),3.) / (2.*(1. - mass/length(p)));
	d = normalize(d-l*fieldDeriv);
   }     
      
   gl_FragColor = vec4(tc+(1.-td)*step(mass*mass*2.,dot(p,p))*((fpn(d*10.)+.5)*vec3(.3,0.,1.)+(fpn(d*100.)+.5)*vec3(.2,.1,.3)), 1.0);
}