// Posted by las
// http://www.pouet.net/topic.php?which=7920&page=29&x=14&y=9
// Forked by Pavlos Mavridis to make it look like the sun

// Sun mod

//the sun is not not a spikeball, is just a sphere ;)

// size optimization attempt by cmr/DESiRE

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi 3.14159265

float hash( float n ) { return fract(sin(n)*43758.5453); }

float noise( in vec3 x )
{
	vec3 p = floor(x);
	vec3 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0 + p.z * 43.0;
    	float res1 = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+57.0+1.0),f.x),f.y);
    	float res2 = mix(mix(hash(n+43.0), hash(n+43.0+1.0),f.x), mix(hash(n+43.0+57.0), hash(n+43.0+57.0+1.0),f.x),f.y);
	float res = mix(res1, res2, f.z);
    	return res;
}

float fpn(vec3 p) {
   return noise(p*.06125)*.56 + noise(p*.5)*.25 + noise(p*.25)*.125;
}

float cloud(vec3 p) {
	float f = 0.0;
    	f += 0.50000*noise(p*1.0*10.0); 
    	f += 0.25000*noise(p*2.0*10.0); 
    	f += 0.12500*noise(p*4.0*10.0); 
    	f += 0.25*noise(p*8.0*10.0);	
	f *= f;
	return f;
}


float sphere(vec3 p) {
   return length(p)-2.5;
}

float f(vec3 p) {
   p.z += 6.;
   return sphere(p) + cloud(p*.5+time*.1) * 0.90+1.0;
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
   
   // i: 0 <= i <= 1.
   // r: length of the ray
   // l: distance function
   float i, r, l, b=0.;

   // rm loop
   for (float i=0.; (i<1.); i+=1./32.) {
      if(td > .95)
           break;
      // evaluate distance function
      l = f(p) * 0.7;
      
      // check whether we are close enough
      if (l < .01) {
        // compute local density and weighting factor 
        ld = 0.01 - l;
        w = (1. - td) * ld;   
        
	    
        // accumulate color and density
        td += w;
      }
      
      // enforce minimum stepsize
      l = max(l, 0.03);
      
      // step forward
      p += l*d;
      r += 1.;
   }     
      
   gl_FragColor = vec4(td*2., ld*3., 0, 1);
}