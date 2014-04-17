// Based off of post by las
// http://www.pouet.net/topic.php?which=7920&page=29&x=14&y=9

// Storm Clouds - tz


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

float sphere( vec3 p ) {
  return length(p) - 0.55;
}

float spheres( vec3 p ) {
	float scale = 0.6;
	return sphere(scale*vec3(sin(p.x + sin(p.x)*sin(p.z) + 0.125*time),p.y + 3.0, -cos(p.z + 0.25*time))* 0.8) /scale;	
}

float f(vec3 p) {
   R(p.xy, pi);
   R(p.xz, 0.0);
   return spheres(p) +  fpn(p*30.) * 0.525;
}

void main(void) {
   // p: position on the ray
   // d: direction of the ray
   vec3 p = vec3(0.,0.,1.2);
   vec3 d = vec3((gl_FragCoord.xy/(0.5*resolution)-1.)*vec2(resolution.x/resolution.y,1.0), 0.) - p + vec3(mouse.x-0.5, mouse.y, 0.0);
   d = normalize(d); 
   
   // ld, td: local, total density 
   // w: weighting factor
   float ld = 0., td = 0.;
   float w = 0.;
   
   // sky coloring
   float height_factor = pow( 1.0 - d.y, 6.75 );
   vec3 zenith_color = vec3(0.192, 0.272, 0.41156);
   vec3 horizon_color = vec3(0.3098, 0.4745, 0.8039);
   vec3 tc = mix( zenith_color, horizon_color, clamp( height_factor, 0.0, 1.0 ) );
   
   // i: 0 <= i <= 1.
   // r: length of the ray
   // l: distance function
   float i = 0., r = 0., l = 0., b = 0.;

   // rm loop
   if (d.y>0.) for (float i=0.; (i<1.); i+=1./56.) {
	   if(!((i<1.) && (l>=0.001*r) && (r < 25.)&& (td <= 1.0))) break;
	   
      // evaluate distance function
      l = f(p) * 0.85;
      
      // check whether we are close enough
      if (l < .07) {
        // compute local density and weighting factor 
        ld = 0.07 - l;
        w = (0.5 - td) * ld;   
        
        // accumulate color and density
        tc += w; //* hsv(w, 1., 1.); 
        td += w;
      }
      td += 1./90.;
      
      // enforce minimum stepsize
      l = max(l, 0.1);
      
      // step forward
      p += l*d;
      r += l;
   }     
      
   gl_FragColor = vec4(tc, 1.0);
}