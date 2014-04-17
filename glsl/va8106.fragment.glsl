// from jspride invitation ! ==> http://www.pouet.net/prod.php?which=61280

precision highp float;

uniform float time;
uniform vec2 resolution;

const float a=1e4;
const vec3 b=vec3(.7,.9,1);
const float c=.004;
const vec3 d=vec3(.5,1,.9);

#define track http://soundcloud.com/chipdisko/usk-error-3003
#define smoothing .75
#define pixel_scale 2
#define author me
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}
vec3 rep( vec3 p, vec3 c )
{
    return mod(p,c)-0.5*c;
}
vec3 rot(vec3 p, float a)
{
   return vec3(p.x, sin(a)*p.z+ cos(a)*p.y, sin(a)*p.y-cos(a)*p.z);
}
float scene(vec3 pos) 
 { 
    //return distance(pos, vec3(0.5,0.5,0.0) ); 
    
  vec3 p = pos;
  
  float a = time;
  p = p.xzy;
  //p.x += sin(0.1*time);
  p = rep(p, vec3(2., 2., 2.));
  //p.x += 0.2*sin(p.y*40.0);
  
  p = rot(p, time+pos.z*0.4);
  float d = sdTorus(p, vec2(0.5,0.2) );
  
  
  
    
  return d;
}
vec3 norm(vec3 pos)
{
  float eps = 0.01;
  return normalize(
      
      
      vec3( 
        scene(pos - vec3(eps,0.0, 0.0)) - scene(pos + vec3(eps, 0.0, 0.0)),                             
        scene(pos - vec3(0.0,eps, 0.0)) - scene(pos + vec3(0.0, eps, 0.0)),
        scene(pos - vec3(0.0,0.0, eps)) - scene(pos + vec3(0.0, 0.0, eps)))    
);
}
vec3 scenecol(vec3 pos)
{
  float d = scene(pos);
  return vec3(1.0-d, 0.0, 0.0);
}

vec3 pixel(vec2 pos) {
  
  
  vec3 sum;
	//movement
  vec3 p = vec3(sin(time), 0.0, time*15.);
  
  vec3 dir = normalize( vec3(pos.x-0.5, pos.y-0.5, 1.0));
  for (int i=0; i<50; ++i)
  {
      float s = scene(p);
      if (s < 0.01)
      {
          // ambient
         vec3 c = vec3(0.3, 0.4, 0.1);
         
         // light
         
        vec3 snorm = norm(p);
         vec3 lnorm = normalize(vec3(2.0,-5.5,1.0) - p);
         float L = max(0.0, dot( lnorm, snorm ));
          
        c += L * vec3(1.0, 1.0, 1.0);
          
         float nebel = length(p);
          return c;
      }
      p += s * dir * 0.6;
          
  }
  return vec3(scene(p));
}

void main(){
	gl_FragColor = vec4(pixel(vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y)), 1.0);
	
}