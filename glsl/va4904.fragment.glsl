#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Simplex noise is implemented by the functions:
float snoise(vec2 P);
float snoise(vec3 P);
float snoise(vec4 P);

#define ONE 0.00390625
#define ONEHALF 0.001953125

const float PI = 3.14159;
const int MAX_RAYMARCH_ITER = 200;
const float MIN_RAYMARCH_DELTA = 0.0001;

uniform sampler2D permTexture;
uniform sampler2D simplexTexture;
uniform sampler2D gradTexture;

//Noise functions used from:
/*
 * Author: Stefan Gustavson ITN-LiTH (stegu@itn.liu.se) 2004-12-05
 * You may use, modify and redistribute this code free of charge,
 * provided that my name and this notice appears intact.
 */



/*
 * 2D simplex noise. Somewhat slower but much better looking than classic noise.
 */
float snoise(vec2 P) {

// Skew and unskew factors are a bit hairy for 2D, so define them as constants
// This is (sqrt(3.0)-1.0)/2.0
#define F2 0.366025403784
// This is (3.0-sqrt(3.0))/6.0
#define G2 0.211324865405

  // Skew the (x,y) space to determine which cell of 2 simplices we're in
 	float s = (P.x + P.y) * F2;   // Hairy factor for 2D skewing
  vec2 Pi = floor(P + s);
  float t = (Pi.x + Pi.y) * G2; // Hairy factor for unskewing
  vec2 P0 = Pi - t; // Unskew the cell origin back to (x,y) space
  Pi = Pi * ONE + ONEHALF; // Integer part, scaled and offset for texture lookup

  vec2 Pf0 = P - P0;  // The x,y distances from the cell origin

  // For the 2D case, the simplex shape is an equilateral triangle.
  // Find out whether we are above or below the x=y diagonal to
  // determine which of the two triangles we're in.
  vec2 o1;
  if(Pf0.x > Pf0.y) o1 = vec2(1.0, 0.0);  // +x, +y traversal order
  else o1 = vec2(0.0, 1.0);               // +y, +x traversal order

  // Noise contribution from simplex origin
  vec2 grad0 = texture2D(permTexture, Pi).rg * 4.0 - 1.0;
  float t0 = 0.5 - dot(Pf0, Pf0);
  float n0;
  if (t0 < 0.0) n0 = 0.0;
  else {
    t0 *= t0;
    n0 = t0 * t0 * dot(grad0, Pf0);
  }

  // Noise contribution from middle corner
  vec2 Pf1 = Pf0 - o1 + G2;
  vec2 grad1 = texture2D(permTexture, Pi + o1*ONE).rg * 4.0 - 1.0;
  float t1 = 0.5 - dot(Pf1, Pf1);
  float n1;
  if (t1 < 0.0) n1 = 0.0;
  else {
    t1 *= t1;
    n1 = t1 * t1 * dot(grad1, Pf1);
  }
  
  // Noise contribution from last corner
  vec2 Pf2 = Pf0 - vec2(1.0-2.0*G2);
  vec2 grad2 = texture2D(permTexture, Pi + vec2(ONE, ONE)).rg * 4.0 - 1.0;
  float t2 = 0.5 - dot(Pf2, Pf2);
  float n2;
  if(t2 < 0.0) n2 = 0.0;
  else {
    t2 *= t2;
    n2 = t2 * t2 * dot(grad2, Pf2);
  }

  // Sum up and scale the result to cover the range [-1,1]
  return 70.0 * (n0 + n1 + n2);
}

float rand(vec3 p)
{
	
  return fract(sin(dot(p, vec3(12.9898, 78.233, 113.57621)))* 43758.5453);
}

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}
float map(vec3 p, vec3 ray_dir) 
{ //  ray_dir is used only for some optimizations
    float plane = sdPlane(p + vec3(0,0.3,0), vec4(normalize(vec3(0, 1, -0.5)),0));

    if (ray_dir.z <= 0.0 || p.z < 1.0) { // Optimization: try not to compute blobby object distance when possible
        float sphere1 = sdSphere(p + vec3(cos(time * 0.2 + PI) * 0.45,0,0), 0.25);
	float Rbox  = udRoundBox(p + vec3(cos(time * 0.2 + PI) * 0.45,0,0), vec3(0.1,0.1,0.1), 0.01);
        return min(min(Rbox,sphere1), plane);
    } else {
        return plane;
    }
}
bool raymarch(vec3 ray_start, vec3 ray_dir, out float dist, out vec3 p, out int iterations) 
{
    dist = 0.0;
    float minStep = 0.0001;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) 
    {
        p = ray_start + ray_dir * dist;
        float mapDist = map(p, ray_dir);
        if (mapDist < MIN_RAYMARCH_DELTA) 
	{
           iterations = i;
           return true;
        }
        if(mapDist < minStep) { mapDist = minStep; }
	    
        dist += mapDist;
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

void main( void ) 
{
	gl_FragColor = vec4( abs(snoise((gl_FragCoord.xy)/(400. + time/100.))), 0.,0.,0.);
}