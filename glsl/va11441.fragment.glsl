#ifdef GL_ES
precision highp float;
#endif

//#define R3

uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;
uniform vec2  surfaceSize;
varying vec2  surfacePosition;

float R = 0.0;
float G = 0.4;
float B = 0.7;

const int Iterations = 50;
const float Radius = 1.33200;
const float Power  = 0.60000;
const float Divider = 35.00000;
const float Escape  = 100.0;

vec2 rot = vec2(1.0, 0.0);

vec3 doColor(int i, vec2 p, float d)
{
  // The color scheme here is based on one
  // from Inigo Quilez's Shader Toy:
  float co = float(i) + 1.0 - log2(.5*log2(dot(p,p)));
  co = sqrt(co/256.0);
  float  co2 = d * Divider;
  float fac = clamp(1.0/pow(co2,Power),0.0,1.0);

  return fac*vec3( .5+.5*cos(6.2831*co+R),
		   .5+.5*cos(6.2831*co+G),
		   .5+.5*cos(6.2831*co+B) );
}
vec3 doColor(int i, float d)
{
  // The color scheme here is based on one
  // from Inigo Quilez's Shader Toy:
  float co =  float(i) + 1.0 - log2(.5*log2(d));
  co = sqrt(co/256.0);
  return vec3(.5+.5*cos(6.2831*co+R),
	      .5+.5*cos(6.2831*co+G),
	      .5+.5*cos(6.2831*co+B));
}

vec2 zpow2(vec2 a) 
{
  float x = (a.x + a.y)*(a.x - a.y); // a.x*a.x - a.y*a.y
  float y = (a.x * a.y);
  return vec2(x, y+y);
}


vec3 colorq(vec2 c)
{
  vec2 p = c;
  float t = surfacePosition.y;
  vec2 k = vec2(-1.0, 0.0) + 0.25*rot;
  vec2 z;
  int  i = 0;
	float dist = 10000.0;

  float theta = time * 0.25;
  float ct = cos(theta);
  float st = cos(theta);

  k = 0.6*vec2(ct*sin(theta*0.7), st+st);

  float cmagsq = dot(k,k);//(p *p + q* q);
  float cmag = sqrt(cmagsq);//sqrt(p *p + q* q);
  float drad = 0.04;
  float drad_L = (cmag - drad);
   drad_L = drad_L * drad_L;
  float drad_H = (cmag + drad);
   drad_H = drad_H * drad_H;


  for (int i = 0; i < Iterations; i++) {
    p = zpow2(p)+k;
    dist = min(dist, abs(length(p)-Radius));
    if (dot(p,p)> 100.0) {
      return doColor(i, p, dist);
    }
  }
  return vec3(0.0);
}

void main(void) 
{
  vec2  p = surfacePosition * 2.0;
  float t = time * 0.5;
  vec3  c = colorq(p);
  
  gl_FragColor.rgb = c;
  gl_FragColor.a   = 1.0;
}
