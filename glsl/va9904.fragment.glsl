// hacked from a Fragmentaium example
//
// http://glsl.heroku.com/e#9904.1
//
// power-2 mandelbrot with rotation not about origin (mouse position) + constant rotation
// p' = r(p-c)^2 + c + p0

#ifdef GL_ES
precision highp float;
#endif

const float Radius = 1.33200;
const float Power  = 0.60000;
const float Divider = 35.00000;

uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;
uniform vec2  surfaceSize;
varying vec2  surfacePosition;

const float R = 0.0;
const float G = 0.4;
const float B = 0.7;

const int Iterations = 50;

vec2 rot = vec2(1.0, 0.0);

vec3 doColor(int i, vec2 z)
{
  // The color scheme here is based on one
  // from Inigo Quilez's Shader Toy:
  float co =  float(i) + 1.0 - log2(.555*log2(dot(z,z)));
  co = sqrt(co/256.0);
  return vec3(.5+.5*cos(6.2831*co+R),
	      .5+.5*cos(6.2831*co+G),
	      .5+.5*cos(6.2831*co+B));
}

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

// double angle wrt positive-x axis
vec2 px2(vec2 z)
{
  float x = (z.x + z.y)*(z.x - z.y);
  float y = z.x * z.y;
  return vec2(x, y+y);
}

vec2 cmul(vec2 a, vec2 b) 
{
  return vec2(a.x*b.x- a.y*b.y, a.x*b.y+a.y*b.x);
}

vec3 colorq(vec2 c, vec2 m)
{
  vec2 p = vec2(0.0);
  vec2 z;
  int  i = 0;
  float dist = 10000.0;
	
  for (int i = 0; i < Iterations; i++) {
    p = cmul(px2(p-m),rot)+c+m;
    dist = min(dist, abs(length(p)-Radius));
	  
    if (dot(p,p)> 100.0) {
       return doColor(i, p, dist);
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
  
  vec3 c = colorq(p, mousePosition);
  
  gl_FragColor.rgb = c;
  gl_FragColor.a   = 1.0;
}
