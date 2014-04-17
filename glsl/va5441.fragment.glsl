// 00f404afdd835ac3af3602c8943738ea - please mark changes (and/or add docs), and retain this line.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;


float _MinStep = 0.0125;

//////////////////////////////////////////////////////////////
// http://www.gamedev.net/topic/502913-fast-computed-noise/
//  simplified, and broken on purpose. fullreset
vec4 random4 (const vec4 x) {
    vec4 z = mod(mod(x, vec4(5612.0)), vec4(3.1415927 * 2.0));
    return fract ((z*z) * vec4(56812.5453));
}
const float A = 1.0;
const float B = 57.0;
const float C = 113.0;
const vec3 ABC = vec3(A, B, C);
const vec4 A3 = vec4(0, B, C, C+B);
const vec4 A4 = vec4(A, A+B, C+A, C+A+B);
float cnoise4 (const in vec3 x) {
    vec3 fx = fract(x);
    vec3 ix = x-fx;
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);
    vec4 R = random4(nn+A3);
    float re = mix(mix(R.x, R.y, wx.y), mix(R.z, R.w, wx.y), wx.z);
    return 1.0 - 2.0 * re;
}

//////////////////////////////////////////////////////////////
// distance functions
// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdSphere( vec3 p, float s ) { return length(p)-s; }
float udBox( vec3 p, vec3 b ) {  return length(max(abs(p)-b,0.0)); }
float udRoundBox( vec3 p, vec3 b, float r ) { return length(max(abs(p)-b,0.0))-r; }
float sdTorus( vec3 p, vec2 t ) { vec2 q = vec2(length(p.xz)-t.x,p.y);  return length(q)-t.y; }
vec3  opRep(vec3 p, vec3 r) { return mod(p,r)-0.5*r; }
vec3  opTx(vec3 p, mat4 m ) { return (m*vec4(p,1.0)).xyz; }
/////////////////////////////////////////////////////
// the rest

float fbm(vec3 p) {
 float N = 0.0;
  float D = 0.0;
  int i=0;
  float R = 0.0;
  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
//  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
//  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
//  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
  return N/D;
}
float scene(vec3 p) { 
  vec3 f = opRep(p * 1.0,vec3(2.7,17.,7.7));
  float d = udRoundBox(f,vec3(1.,0.,1.),0.15);
	
//  d = min(d,udRoundBox(p-pw*2.,vec3(100.,80.,.2),0.22));

   vec3 c = opRep(p,vec3(20.,4.6,14.))-vec3(0.,0.,7.);
   d = min(d,udRoundBox(c,vec3(1.75,2.,0.75),0.15));
	
  float n = fbm(p*10.0);  	
  return d+n*pow(sin(time) * 0.5 + 0.5, 5.0);
}

vec4 color(float d) {  return vec4(.125,d*5.,1.0,0.1)*float(d<0.2); }

vec4 ray(vec3 pos, vec3 step) {
  vec4 sum = vec4(0.);
  vec4 col;
  float d = 9999.0;
#define RAY1  { d = scene(pos); col = color(d); col.rgb *= col.a; sum += col*(1.0 - sum.a); pos += step*max(d,_MinStep); }
#define RAY4  RAY1 RAY1 RAY1 RAY1
  RAY4 RAY4 RAY4 RAY4
	  //sum += vec4(d, d * 0.5, d * 0.85, 0.0);
  return sum;
}

void main( void ) {
  vec3 e = vec3(sin(time*0.2)*20.,12.,-1.); 
  vec3 p = vec3((gl_FragCoord.xy / resolution.xy) * 2. -1., 1.);
  p.x *= resolution.x/resolution.y;
  p += e;
  gl_FragColor = ray(p, normalize(p-e));
}