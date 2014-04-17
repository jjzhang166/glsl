// hacked from a Fragmentaium example
//
// http://glsl.heroku.com/e#9916.1
//
// power-2 mandelbrot, doubling the angles wrt to two directed lines per iteration. The first
// is in the positive-x direction centered about the mouse position.  The second is rotating
// with time through the origin. Both use the original sample position as the translation to
// complete the fold.

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



// double angle wrt direct line 'l' through origin, 
// square magnitude assuming 'l' is unit length
vec2 doubleAngle(vec2 p, vec2 l)
{
  float a = (p.x + p.y);
  float s = (p.x - p.y);
  float b = 2.0 * p.x * p.y;
  float x = l.y * b + a * s * l.x;   // (x-y)(x+y)cos(t) + 2xy sin(t)
  float y = l.x * b - a * s * l.y;   // (y-x)(x+y)sin(t) + 2xy cos(t)

  return vec2(x, y);
}

// double angle wrt positive-x (square magnitude)
vec2 px2(vec2 p)
{
  float x = (p.x + p.y)*(p.x - p.y);
  float y = (p.x * p.y);
  return vec2(x, y+y);
}

// double angle wrt positive-y (square magnitude)
vec2 py2(vec2 p)
{
  float y = (p.x + p.y)*(p.y - p.x);
  float x = (p.x * p.y);
  return vec2(x+x, y);
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
  vec2 l = vec2(0.0, 1.0);
  float dist = 10000.0;
	
  for (int i = 0; i < Iterations; i++) {
    p = px2(p-m)+m+c;
    p = doubleAngle(p, rot)+c;
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
