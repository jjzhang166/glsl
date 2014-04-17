#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void rX(inout vec3 p, float a) { float c,s;vec3 q=p; c = cos(a); s = sin(a); p.y = c * q.y - s * q.z; p.z =  s * q.y + c * q.z; }
void rY(inout vec3 p, float a) { float c,s;vec3 q=p; c = cos(a); s = sin(a); p.x = c * q.x + s * q.z; p.z = -s * q.x + c * q.z; }
void rZ(inout vec3 p, float a) { float c,s;vec3 q=p; c = cos(a); s = sin(a); p.x = c * q.x - s * q.y; p.y =  s * q.x + c * q.y; }

float sphere(vec3 p, float s)
{
   return length(p)-s;
}

vec3 map(vec3 p)
{
   vec3 q = p;
   
   vec2 d1 = vec2(sphere(q,.6),1.);
   
   return vec3(d1,1.0);
}

vec2 intersect(in vec3 ro, in vec3 rd)
{
   // GL-ES hack for non-constant loop
   float t = 0.0;
   for (float l = 0.0; l < 10.0; l += 0.1)
   {
       vec3 h = map(ro+rd*t);
       if (h.x < .0001) return vec2(h.z,h.y);
       t += h.x;
   }
  
   return vec2(0);
}

void main( void ) {
	vec2 p=(gl_FragCoord.xy/resolution.xy);
	vec2 ratio = vec2(resolution.x/resolution.y,1.0);
 
	   vec3 ro = vec3(0,0,1.0);
	   vec3 rd = normalize(vec3((-1.+2.*p)*ratio,-1.));
 
	   vec3 color = vec3(0);
   
	   vec2 t = intersect(ro,rd);
   
	   if (t.x > .2)
	   {
	       color = vec3(1.);
	   }
   
	   gl_FragColor = vec4(color,1.0);
}