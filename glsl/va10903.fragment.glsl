
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

#ifdef GL_ES
precision highp float;
#endif

// choose an inversion point for example set
#define FIXED_POINT 29

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

#if defined(FIXED_POINT)
float getPoint(inout vec2 InvertC, inout vec2 Center)
{
  const int t = FIXED_POINT;
  float Zoom = 1.0;

  Center = vec2(0.0);

  if (t==0) { // Default
    Center = vec2(8.06362,3.80564);
    Zoom = 0.09133;
    InvertC = vec2( 0.28204,0.35896);
  } else if (t==1) { // Origin
    Center = vec2(0.77703,-0.16391);
    Zoom = 0.29803;
    InvertC = vec2( 0.0, 0.0);
  } else if (t==2) { // Cusp
    Center = vec2( 10.00000,-0.34754);
    Zoom = 0.09133;
    InvertC = vec2( 0.25, 0.0);
  } else if (t==3) { // Cusp1
    Center = vec2( -32.1753,113.933);
    Zoom = 0.00692533;
    InvertC = vec2( 0.27, 0.0);
  } else if (t==4) { // Cusp2
    Center = vec2(  52.2699,-120.126);
    Zoom = 0.00665366;
    InvertC = vec2( 0.27,0.01);
  } else if (t==5) { // Cusp3
    Center = vec2(  4.41356,-2.68176);
    Zoom =  0.141913;
    InvertC = vec2(0.24,0.11);
  } else if (t==6) { // Spike
    Center = vec2( 2.66332,-0.0635439);
    Zoom = 0.463974;
    InvertC = vec2(-2.0,0.0);
  } else if (t==7) { // Spike1
    Center = vec2( 61.9013,-9.59081);
    Zoom = 0.000344353;
    InvertC = vec2(-1.5,0.0);
  } else if (t==8) { // Spike2
    Center = vec2( -122.96,-144.132);
    Zoom = 0.00449765;
    InvertC = vec2( -1.5,0.01);
  } else if (t==9) { // Seahorse1
    Zoom = 0.0677466;
    InvertC = vec2( -0.75,0);
  } else if (t==10) { // Seahorse2
    Center = vec2( 892.182,446.339);
    Zoom = 0.000872917;
    InvertC = vec2( -0.75,0.1);
  } else if (t==11) { // Seahorse3
    Center = vec2( 47.6429,22.2993);
    Zoom = 0.0139391;
    InvertC = vec2( -0.78,0.1);
  } else if (t==12) { // Seahorse4
    Center = vec2( 1837.16,16707.2);
    Zoom = 1.95694e-05;
    InvertC = vec2( -0.78,0.15);
  } else if (t==13) { // Seahorse5
    Center = vec2( 692.895,6717.62);
    Zoom = 2.94738e-05;
    InvertC = vec2( -0.79,0.151);
  } else if (t==14) { // Seahorse6
    Center = vec2( -27.6194,-201.941);
    Zoom = 0.000530689;
    InvertC = vec2( -0.79,0.161);
  } else if (t==15) { // TripleSpiral1
    Center = vec2( -665.699,1084.26);
    Zoom = 0.000541372;
    InvertC = vec2( -0.088,0.654);
  } else if (t==16) { // TripleSpiral2
    Center = vec2( -471.261,-78.1761);
    Zoom = 6.68937e-05;
    InvertC = vec2( -0.0881,0.656);
  } else if (t==17) { // Elephant1
    Center = vec2( -35.697,-2.74368);
    Zoom = 0.005104;
    InvertC = vec2( 0.275,0);
  } else if (t==18) { // Elephant2
    Center = vec2( -61.6772,129.984);
    Zoom = 0.00378155;
    InvertC = vec2( 0.275,0.003);
  } else if (t==19) { // Elephant3
    Center = vec2( -61.6772,129.984);
    Zoom = 0.00023;
    InvertC = vec2( 0.30103,0.01900);
  } else if (t==20) { // QuadSpiral1
    Center = vec2( -81.2003,2.93696);
    Zoom = 0.00200489;
    InvertC = vec2( 0.274,0.482);
  } else if (t==21) { // Scepter1
    Center = vec2( -55.2591,-6.69168);
    Zoom = 0.0109733;
    InvertC = vec2( -1.36,0.005);
  } else if (t==22) { // Scepter2
    Center = vec2( -70.6074,15.829);
    Zoom = 0.000851378;
    InvertC = vec2( -1.38,0.015);
  } else if (t==23) { // ScepterV
    Zoom = 0.00151033;
    InvertC = vec2( -1.108,0.23);
  } else if (t==24) { // TooMuch1
    Center = vec2( -0.780031,-0.0229885);
    Zoom = 0.155172;
    InvertC = vec2( -0.75,0.01101);
  } else if (t==25) { // TooMuch2
    Center = vec2( 57770,-34648);
    Zoom = 1.52724e-05;
    InvertC = vec2( -0.75,0.01101);
  } 
	
	//Fix for the nvidia card on my laptop
/*else if (t==26) { //  Feigenbaum
    Zoom = 0.00029;
    InvertC = vec2( -1.40115,0.0);
  } else if (t==27) { //  Feigenbaum2
    Zoom = 2.94208e-05;
    InvertC = vec2( -0.1528,1.0397);
  } else if (t==28) { //  Misiurewicz4_1
    Zoom = 0.001;
    InvertC = vec2( -0.1011,0.9563);
  } else if (t==29) { // Mini1
    Zoom = 0.00329094;
    InvertC = vec2( -0.15908,1.03282);
  } else if (t==30) { //  Misiurewicz23_2
    Zoom = 8.87943e-05;
    InvertC = vec2( -0.77568,0.13646);
  } else if (t==31) { //  Minus1
    Zoom = 0.15741;
    InvertC = vec2( -1.0,0.0);
  } else if (t==32) { //  Minus1_p25
    Zoom = 0.02816;
    InvertC = vec2( -1.0,0.25);
  } else if (t==33) { //  Minus1p27
    Zoom = 0.02816;
    InvertC = vec2( -1.27,0.25);
  } else if (t==34) { //  PeriodicPoint_3_1
    Zoom = 0.0053494;
    InvertC = vec2( -1.75488,0);
  } else if (t==35) { //  PeriodicPoint_3_2
    Zoom =0.08773;
    InvertC = vec2( -0.122561,0.744862);
  } else if (t==36) { //  PeriodicPoint_3_2
    Zoom =0.08773;
    InvertC = vec2( -0.122561,0.744862);
  } else if (t==37) { // Foo1
    Zoom = 1.93822e-05;
    InvertC = vec2( 0.43845,-0.3571);
  } else if (t==38) { // Foo2
    Center = vec2( 7951.2,5050.73);
    Zoom = 5.73643e-05;
    InvertC = vec2( -0.5714,-0.5);
  } else if (t==39) { // Foo3
    Zoom = 0.00003;
    InvertC = vec2(-1.27000,0.05101);
  } else if (t==40) { // Foo4
    Zoom = 9.53958e-05;
    InvertC = vec2( -1.25,0.021);
  }
*/
  return Zoom;
}
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
  vec2 k,o;

  s /= 4.0*getPoint(k,o);
 
  vec2 p = 2.0 * surfacePosition + o/surfaceSize.y ;//- vec2(0.5, 0.0);

  c = colorq(s*p, k);

  //float dd = dot(p,p); if (dd < 0.0002) c = vec3(1.0,0.0,0.0);

#else
  vec2 p = 2.0 * surfacePosition - vec2(0.5, 0.0);
  vec2 mousePosition = (mouse - (gl_FragCoord.xy / resolution)) * surfaceSize + surfacePosition;
  mousePosition = mousePosition * 2.0 - vec2(0.5, 0.0);

  c = colorq(s*p, mousePosition);
#endif
  
  gl_FragColor.rgb = c;
  gl_FragColor.a   = 1.0;
}
