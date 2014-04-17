#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float lowFreq, midFreq, highFreq;

void rX(inout vec3 p, float a) { float c,s;vec3 q=p;	c = cos(a); s = sin(a);	p.y = c * q.y - s * q.z;	p.z = s * q.y + c * q.z; }
void rY(inout vec3 p, float a) {	float c,s;vec3 q=p;	c = cos(a); s = sin(a);	p.x = c * q.x + s * q.z;	p.z = -s * q.x + c * q.z;}

float star(vec3 p, float s) { return length(p)-s; }
float starfield(vec3 p, float s, vec3 c) { vec3 q = mod(p,c)-.5*c; return star(q,s); }
vec2 map(vec3 p)
{
   float a = starfield(p, .1+.05*abs(sin(time)), vec3(1.,1.,1.));
   return vec2(a,1.);
}

vec2 intersect(in vec3 ro, in vec3 rd)
{
   float rt = .0;
   for (float t = .0; t < 100.; t += .0)
   {
       vec2 h = map(ro+rd*rt);
       if (h.x < .0001) return vec2(rt,h.y);
       rt += h.x;
	   
       if (rt >= 100.) break;
   }
   
   return vec2(0);
}

void main( void ) {
   
   vec2 p = -1.0 + 2.0 *  ( gl_FragCoord.xy / resolution.xy );
	  p.x *= resolution.x / resolution.y;

   vec3 ro = vec3(0,0,1.0-time);
   vec3 rd = normalize(vec3(p, -1.));
   rX(rd,mouse.y);
   rY(rd,mouse.x);
   vec3 color = vec3(0);
   
   vec2 t = intersect(ro,rd);
    
   if (t.y > .0) {
      color = vec3(t.x,1.-mod(t.x,1.),abs(sin(time/5.))+.5);
   }
   
   gl_FragColor = vec4(color,1.0);
}