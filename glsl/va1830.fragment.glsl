// Inspiraling black holes by Kabuto. Inspiral itself should be halfway accurate but I don't know how to render gravitational waves yet :(

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi 3.14159265
#define R(p, a) p=cos(a)*p+sin(a)*vec2(p.y, -p.x)
const float mass = .367; // mass (and radius of the event horizon as well)

// Simple 3D noise. No idea who invented this...
float pn(vec3 p) {
   vec3 i = floor(p);
   vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
   vec3 f = cos((p-i)*pi)*(-.5) + .5;
   a = mix(sin(cos(a)*a), sin(cos(1.+a)*(1.+a)), f.x);
   a.xy = mix(a.xz, a.yw, f.y);
   return mix(a.x, a.y, f.z);
}

// 3 frequencies of 3D noise added
float fpn(vec3 p) {
   return pn(p*.06125)*.5 + pn(p*.125)*.25 + pn(p*.25)*.125;
}

const float inspiralDuration = 20.;
const float inspiralDistance = 5000.;

float bhtime = max(0.,fract(-time/inspiralDuration)-.1)*inspiralDistance;
float bhrad = pow(bhtime, .25)*mass;
float bhang = sqrt(bhrad*bhtime/2.);


void main(void) {  
	vec2 d2 = (gl_FragCoord.xy/(0.5*resolution)-1.)*vec2(resolution.x/resolution.y,1.0);
   vec3 d = vec3(2.,d2.x,d2.y);
   d = normalize(d); 
	float t2 = time*.23;
	float t = t2 + sin(t2)*.9;
   vec3 p = vec3(-8,0,0.);
   R(d.xz, -(mouse.y-.5)*2.);
   R(p.xz, -(mouse.y-.5)*2.);
   R(d.xy, -(mouse.x-.5)*1.5);
   R(p.xy, -(mouse.x-.5)*1.5);

	
	   vec3 bhpos = vec3(cos(bhang)*bhrad, sin(bhang)*bhrad, 0);

	   vec3 p1 = p-bhpos;
	   vec3 p2 = p+bhpos;
	float   lof = (1. - mass/length(p1) - mass/length(p2));
	
	float nobh = 1.;
   for (int i = 0; i < 16; i++) {
	float l = mass/(1.-lof)*1.;
      
      p += l*d;
	   p1 = p-bhpos;
	   p2 = p+bhpos;
	   lof = (1. - mass/length(p1) - mass/length(p2));
	vec3 fieldDeriv = (p1 * mass / pow(length(p1),3.) + p2 * mass / pow(length(p2),3.)) / (2.*lof);
	d = normalize(d-l*fieldDeriv);
	 nobh *= step(0.,lof);
   }     
      
   gl_FragColor = vec4(nobh*((fpn(d*10.)+.5)*vec3(.3,0.,1.)+(fpn(d*100.)+.5)*vec3(.2,.1,.3)), 1.0);
}