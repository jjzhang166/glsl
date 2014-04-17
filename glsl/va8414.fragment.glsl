// 00f404afdd835ac3af3602c8943738ea - please mark changes (and/or add docs), and retain this line.
// Underwaterised by psonice.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float _MinStep = 0.0125;

//////////////////////////////////////////////////////////////
// http://www.gamedev.net/topic/502913-fast-computed-noise/
// replaced costly cos with z^2. fullreset
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
float cnoise4 (const in vec3 xx) {
    vec3 x = xx; // mod(xx + 32768.0, 65536.0); // ignore edge issue
    vec3 fx = fract(x);
    vec3 ix = x-fx;
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);

    vec4 N1 = nn + A3;
    vec4 N2 = nn + A4;
    vec4 R1 = random4(N1);
    vec4 R2 = random4(N2);
    vec4 R = mix(R1, R2, wx.x);
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
float cyl(vec3 p, float r, float c) { return max(length(p.xz)-r, abs(p.y)-c); }
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
  float n = fbm(time + p);
  vec3 pw = vec3(0.,0.,10.);
  float pa = udRoundBox(p+pw,vec3(100.,5.,500.),0.22) + .5 *  n;
  float d = pa;

  vec3 c = opRep(p,vec3(20.,5.25,14.))-vec3(0.,0.,7.);
  d = min(d,cyl(c+pw+vec3(0.,0.,-3.),2.,2.5));

  float e = udRoundBox(p-vec3(0.,30.,4.),vec3(100.,0.1,0.1),0.1);
  
  n = fbm(p);  	
  return min(e,sin(p.x * 5.)*.15+cos(p.z * 5.)*.15+n*0.215+d); // 'texture'
}

vec4 color(float d) { 
  return mix(vec4(.7,.6,.3,0.55),vec4(.2,.3,.3,0.1),smoothstep(0.,0.1,d*0.07)); // underwater (ugly) colours
}

vec4 ray(vec3 pos, vec3 step) {
    vec4 sum = vec4(0.);
    vec4 col;
    float d = 9999.0;
	// added position modification based on position y/z values for undulation
#define RAY1  { d = scene(pos); col = color(d); col.rgb *= col.a; sum += col*(1.0 - sum.a); pos += step*max(d*.6,_MinStep); pos.xyz += vec3(0., sin(pos.z*0.2+time)*0.2, sin(pos.z*0.2+time)*0.02*pos.y); }
#define RAY4  RAY1 RAY1 RAY1 RAY1
    RAY4 RAY4 RAY4 RAY4 RAY4 RAY4
    return sum;
}

void main( void ) {
  vec3 e = vec3(sin(time*.2)*2.,12.+cos(time)*0.5,-17.+time*2.+sin(time)*0.5); // swimming motion
  vec3 p = vec3((gl_FragCoord.xy / resolution.xy) * 2. -1., 1.);
  p.x *= resolution.x/resolution.y;
  p += e;
  gl_FragColor = ray(p, normalize(p-e));
}