precision highp float;
uniform vec2 resolution;
uniform float time;

float oa(vec3 q)
{
// return cos(q.x*.5)+cos(q.y*.7)+cos(q.z*0.5);
// return (sin(q.x*2.0) + sin(q.z*2.1))*0.5 + q.y;

//  vec3 t = vec3( mod(q.x,2.0)-1.0, mod(q.y,2.0)-1.0, mod(q.z,2.0)-1.0); 
  vec3 t = vec3( mod(q.x,0.2)-0.1, mod(q.y,0.2)-0.1, mod(q.z,0.2)-0.1); 

  return sqrt(t.x*t.x+t.y*t.y+t.z*t.z);
}

void main(void)
{
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 vec4 c=vec4(1.0);
 vec3 org=vec3(sin(time*.01)*2.0,cos(time*.05)*2.0,cos(time*.05)*2.0),dir=normalize(vec3(p.x,p.y,2.00)),q=org;

 float ca = cos(time/4.);
 float sa = sin(time/4.);
 vec3 tmp = dir; 
 dir.x = ca * tmp.x - sa * tmp.z; 
 dir.z = sa * tmp.x + ca * tmp.z; 

 dir /= 200.0;
 float steps = 0.0;

 for(int i=0;i<1000;i++)
 {
  if ( oa(q) < 0.01) { steps += 1.0; }
  else
  q += dir;
  dir *= 1.04;
 }

 float f = steps*0.0015;
 gl_FragColor=vec4(f,f,f,1.0);
}