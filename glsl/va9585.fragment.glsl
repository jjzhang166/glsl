// hacked from a Fragmentarium example

#ifdef GL_ES
precision highp float;
#endif

vec3 center = 0.0*vec3(-0.20000, 0.1, -0.2);

uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;
uniform vec2  surfaceSize;
varying vec2  surfacePosition;

float R = 0.0;
float G = 0.4;
float B = 0.7;

const int Iterations = 50;

vec2 rot = vec2(1.0, 0.0);

vec3 doColor(int i, vec3 z)
{
  // The color scheme here is based on one
  // from Inigo Quilez's Shader Toy:
  float co =  float(i) + 1.0 - log2(.555*log2(dot(z,z)));
  co = sqrt(co/256.0);
  return vec3(.5+.5*cos(6.2831*co+R),
	      .5+.5*cos(6.2831*co+G),
	      .5+.5*cos(6.2831*co+B));
}

vec3 qt(vec3 p)
{
  vec3  r;
  float a = (p.x+p.y+p.z);
  float b = (p.x-p.y-p.z);
  float x = a*b + 2.0*p.y*p.z;

  p += center;  
  r  = vec3(abs(x), 2.0*p.x*p.z, 2.0*p.x*p.y);
  r -= center;  
  return r;
}

vec3 colorq(vec2 c)
{
  vec3 k = vec3(c.x, rot.x*c.y, rot.y*c.y);
  vec3 p = vec3(0.0);
  vec2 z;
  int  i = 0;
	
  for (int i = 0; i < Iterations; i++) {
    p = qt(p)+k;
	  
    if (dot(p,p)> 100.0) {
       return doColor(i, p);
    }
  }
  return vec3(0.0);
}

void main(void) 
{
  vec2 p = surfacePosition * 2.0 - vec2(0.5, 0.0);
  vec2 mousePosition = (mouse - (gl_FragCoord.xy / resolution)) * surfaceSize + surfacePosition;
  mousePosition = mousePosition * 2.0 - vec2(0.5, 0.0);
  float t = time * 0.5;

  rot = vec2(cos(t),sin(t));
  
  vec3 c = colorq(p);
  
  gl_FragColor.rgb = c;
  gl_FragColor.a   = 1.0;
}
