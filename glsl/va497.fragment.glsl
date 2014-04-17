precision highp float;
uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

float oa(vec3 q)
{
  vec3 t = vec3( mod(q.x,0.2)-0.1, mod(q.y,0.2)-0.1, mod(q.z,0.2)-0.1); 
  return sqrt(t.x*t.x+t.y*t.y+t.z*t.z);
}

void main(void)
{
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 vec3 org=vec3(cos(time*.01)*2.0,cos(time*.05)*2.0,cos(time*.05)),dir=normalize(vec3(p.y,p.x,.5)),q=org;

 float ca = cos(time/10.);
 float sa = sin(time/10.);
 vec3 tmp = dir; 
 dir.x = ca * tmp.x - sa * tmp.z; 
 dir.z = sa * tmp.x + ca * tmp.z; 

 dir /= 200.0;
 float steps = 0.0;

 for(int i=0;i<100;i++)
 {
  if ( oa(q) < 0.01) { steps += 0.5; }
  else
  q += dir;
  dir *= 1.04;
 }

 float f = steps*0.05;
 gl_FragColor=vec4(tan(f),f*time*0.1,f*cos(time),1.0);
}