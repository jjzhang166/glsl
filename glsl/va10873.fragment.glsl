
// ROQUEN: standard m-set with a simple change of domain on the input set.
//
// THIS IS A MASSIVE QUICK HACK FROM THE FRAGMENTARIUM FILE...VERY BROKEN
// AND SHOULD ADD QUICK EXITS FOR PERFORMANCE.
//
// 1) Set sampling to .5
// 2) Crank up "Iterations" until your GPU crys for mercy
// 3) Set FIXED_POINT macro below. Commenting out uses mouse input for inversion point, but
//    this is basically useless for this transform. (most interesting values tiny changes
//    drastically change the visualization)
//
// Specifically:
// p' = p^2 + c, where c = k+d/dot(d,d), with d = s-k, s=input domain sampling point and
// k = a point of inversion.
//
// This sends 'k' to the point at infinity.  So this is a magnitude inversion about point 'k', 
// circle inversion of radius '1' with center 'k' or a north-south hemisphere swap on the
// R-sphere...take your choice.

// SEE: for some stills: http://roquendm.deviantart.com/gallery/

// CHANGELOG:
// 3: fixed stupid mistake than made most of the example points borked
// 2: quick hack to fix quick hack 1
// 1: quick hack to change from function to macros (see below)
// 0: initial version

#ifdef GL_ES
precision highp float;
#endif

// choose an inversion point for example set
#define FIXED_POINT 32

// comment out for escape time
#define ORBIT

#define PRE_SCALE 5.0

const int Iterations = 550;


const float Escape  = 100.0;

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

// changed to macro mess to be runnable on more GPU/driver combos
#if defined(FIXED_POINT)
  #if (FIXED_POINT==0) // Default
    #define CENTER vec2(8.06362,3.80564)
    #define ZOOM 0.09133
    #define INVERT_K vec2( 0.28204,0.35896)
  #elif (FIXED_POINT==1) // Origin
    #define CENTER vec2(0.77703,-0.16391)
    #define ZOOM 0.29803
    #define INVERT_K vec2( 0.0, 0.0)
  #elif (FIXED_POINT==2) // Cusp
    #define CENTER vec2( 10.00000,-0.34754)
    #define ZOOM 0.09133
    #define INVERT_K vec2( 0.25, 0.0)
  #elif (FIXED_POINT==3) // Cusp1
    #define CENTER vec2( -32.1753,113.933)
    #define ZOOM 0.00692533
    #define INVERT_K vec2( 0.27, 0.0)
  #elif (FIXED_POINT==4) // Cusp2
    #define CENTER vec2(  52.2699,-120.126)
    #define ZOOM 0.00665366
    #define INVERT_K vec2( 0.27,0.01)
  #elif (FIXED_POINT==5) // Cusp3
    #define CENTER vec2(  4.41356,-2.68176)
    #define ZOOM  0.141913
    #define INVERT_K vec2(0.24,0.11)
  #elif (FIXED_POINT==6) // Spike
    #define CENTER vec2( 2.66332,-0.0635439)
    #define ZOOM 0.463974
    #define INVERT_K vec2(-2.0,0.0)
  #elif (FIXED_POINT==7) // Spike1
    #define CENTER vec2( 61.9013,-9.59081)
    #define ZOOM 0.000344353
    #define INVERT_K vec2(-1.5,0.0)
  #elif (FIXED_POINT==8) // Spike2
    #define CENTER vec2( -122.96,-144.132)
    #define ZOOM 0.00449765
    #define INVERT_K vec2( -1.5,0.01)
  #elif (FIXED_POINT==9) // Seahorse1
    #define ZOOM 0.0677466
    #define INVERT_K vec2( -0.75,0)
  #elif (FIXED_POINT==10) // Seahorse2
    #define CENTER vec2( 892.182,446.339)
    #define ZOOM 0.000872917
    #define INVERT_K vec2( -0.75,0.1)
  #elif (FIXED_POINT==11) // Seahorse3
    #define CENTER vec2( 47.6429,22.2993)
    #define ZOOM 0.0139391
    #define INVERT_K vec2( -0.78,0.1)
  #elif (FIXED_POINT==12) // Seahorse4
    #define CENTER vec2( 1837.16,16707.2)
    #define ZOOM 1.95694e-05
    #define INVERT_K vec2( -0.78,0.15)
  #elif (FIXED_POINT==13) // Seahorse5
    #define CENTER vec2( 692.895,6717.62)
    #define ZOOM 2.94738e-05
    #define INVERT_K vec2( -0.79,0.151)
  #elif (FIXED_POINT==14) // Seahorse6
    #define CENTER vec2( -27.6194,-201.941)
    #define ZOOM 0.000530689
    #define INVERT_K vec2( -0.79,0.161)
  #elif (FIXED_POINT==15) // TripleSpiral1
    #define CENTER vec2( -665.699,1084.26)
    #define ZOOM 0.000541372
    #define INVERT_K vec2( -0.088,0.654)
  #elif (FIXED_POINT==16) // TripleSpiral2
    #define CENTER vec2( -471.261,-78.1761)
    #define ZOOM 6.68937e-05
    #define INVERT_K vec2( -0.0881,0.656)
  #elif (FIXED_POINT==17) // Elephant1
    #define CENTER vec2( -35.697,-2.74368)
    #define ZOOM 0.005104
    #define INVERT_K vec2( 0.275,0)
  #elif (FIXED_POINT==18) // Elephant2
    #define CENTER vec2( -61.6772,129.984)
    #define ZOOM 0.00378155
    #define INVERT_K vec2( 0.275,0.003)
  #elif (FIXED_POINT==19) // Elephant3
    #define CENTER vec2( -61.6772,129.984)
    #define ZOOM 0.00023
    #define INVERT_K vec2( 0.30103,0.01900)
  #elif (FIXED_POINT==20) // QuadSpiral1
    #define CENTER vec2( -81.2003,2.93696)
    #define ZOOM 0.00200489
    #define INVERT_K vec2( 0.274,0.482)
  #elif (FIXED_POINT==21) // Scepter1
    #define CENTER vec2( -55.2591,-6.69168)
    #define ZOOM 0.0109733
    #define INVERT_K vec2( -1.36,0.005)
  #elif (FIXED_POINT==22) // Scepter2
    #define CENTER vec2( -70.6074,15.829)
    #define ZOOM 0.000851378
    #define INVERT_K vec2( -1.38,0.015)
  #elif (FIXED_POINT==23) // ScepterV
    #define ZOOM 0.00151033
    #define INVERT_K vec2( -1.108,0.23)
  #elif (FIXED_POINT==24) // TooMuch1
    #define CENTER vec2( -0.780031,-0.0229885)
    #define ZOOM 0.155172
    #define INVERT_K vec2( -0.75,0.01101)
  #elif (FIXED_POINT==25) // TooMuch2
    #define CENTER vec2( 57770,-34648)
    #define ZOOM 1.52724e-05
    #define INVERT_K vec2( -0.75,0.01101)
  #elif (FIXED_POINT==26) //  Feigenbaum
    #define ZOOM 0.00029
    #define INVERT_K vec2( -1.40115,0.0)
  #elif (FIXED_POINT==27) //  Feigenbaum2
    #define ZOOM 2.94208e-05
    #define INVERT_K vec2( -0.1528,1.0397)
  #elif (FIXED_POINT==28) //  Misiurewicz4_1
    #define ZOOM 0.001
    #define INVERT_K vec2( -0.1011,0.9563)
  #elif (FIXED_POINT==29) // Mini1
    #define ZOOM 0.00329094
    #define INVERT_K vec2( -0.15908,1.03282)
  #elif (FIXED_POINT==30) //  Misiurewicz23_2
    #define ZOOM 8.87943e-05
    #define INVERT_K vec2( -0.77568,0.13646)
  #elif (FIXED_POINT==31) //  Minus1
    #define ZOOM 0.15741
    #define INVERT_K vec2( -1.0,0.0)
  #elif (FIXED_POINT==32) //  Minus1_p25
    #define ZOOM 0.02816
    #define INVERT_K vec2( -1.0,0.25)
  #elif (FIXED_POINT==33) //  Minus1p27
    #define ZOOM 0.02816
    #define INVERT_K vec2( -1.27,0.25)
  #elif (FIXED_POINT==34) //  PeriodicPoint_3_1
    #define ZOOM 0.0053494
    #define INVERT_K vec2( -1.75488,0)
  #elif (FIXED_POINT==35) //  PeriodicPoint_3_2
    #define ZOOM 0.08773
    #define INVERT_K vec2( -0.122561,0.744862)
  #elif (FIXED_POINT==36) //  PeriodicPoint_3_2
    #define ZOOM 0.08773
    #define INVERT_K vec2( -0.122561,0.744862)
  #elif (FIXED_POINT==37) // Foo1
    #define ZOOM 1.93822e-05
    #define INVERT_K vec2( 0.43845,-0.3571)
  #elif (FIXED_POINT==38) // Foo2
    #define CENTER vec2( 7951.2,5050.73)
    #define ZOOM 5.73643e-05
    #define INVERT_K vec2( -0.5714,-0.5)
  #elif (FIXED_POINT==39) // Foo3
    #define ZOOM 0.00003
    #define INVERT_K vec2(-1.27000,0.05101)
  #elif (FIXED_POINT==40) // Foo4
    #define ZOOM 9.53958e-05
    #define INVERT_K vec2( -1.25,0.021)
  #endif
#endif

#if defined(INVERT_K)
const vec2 InvertK = INVERT_K;
#else
const vec2 InvertK = vec2(0.0);
#endif

#if defined(ZOOM)
const float Zoom = 1.0/(4.0*ZOOM);
#else
const float Zoom = 1.0/4.0;
#endif

#if defined(CENTER)
const vec2 Center = CENTER;
#else
const vec2 Center = vec2(0.0);
#endif


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

vec2 pow2(vec2 z)
{
  float x = (z.x + z.y)*(z.x - z.y);
  float y = z.x * z.y;
  return vec2(x, y+y);
}

vec3 colorq(vec2 c, vec2 k)
{
  vec2 p = vec2(0.0);
  vec2 z;
  int  i = 0;
  float dist = 10000.0;

  // perform the domain mapping
  vec2 d = c-k;
  k = k + d/dot(d,d);

  // standard iteration
  for (int i = 0; i < Iterations; i++) {
    p    = pow2(p)+k;

#if defined(ORBIT)
    dist = min(dist, abs(length(p)-Radius));
	  
    if (dot(p,p) > Escape) {
       return doColor(i, p, dist);
    }
#else
    if (dot(p,p) > Escape) {
       return doColor(i, p);
    }
#endif
  }
  return vec3(0.0);
}

void main(void) 
{
  vec3  c;
  float s = PRE_SCALE;

#if defined(FIXED_POINT)
  s *= Zoom;

#if 1
  vec2 p = 2.0 * surfacePosition;
#else
  vec2 p = ((gl_FragCoord.xy/resolution)+Center) * surfaceSize + surfacePosition;
#endif

  c = colorq(s*p+Center, InvertK);

  //float dd = dot(p,p); if (dd < 0.0002) c = vec3(1.0,0.0,0.0);

#else
  vec2 p = 2.0 * surfacePosition - vec2(0.5, 0.0);
  vec2 mousePosition = (mouse - (gl_FragCoord.xy/resolution)) * surfaceSize + surfacePosition;
  mousePosition = mousePosition * 2.0 - vec2(0.5, 0.0);

  c = colorq(s*p, mousePosition);
#endif
  
  gl_FragColor.rgb = c;
  gl_FragColor.a   = 1.0;
}
