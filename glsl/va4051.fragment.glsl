#ifdef GL_ES
precision highp float;
#endif

uniform vec2  resolution;
uniform float time;
uniform vec2  mouse;
const float PI=3.14159265;
// Raymarching sandbox by @PauloFalcao
// Just playing around with domain repitition to produce interesting structures
// With the aim of coming up with some building blocks for larger worlds
// using http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
// experiment by @filipwanstrom


float step(float a, float x){
	return float(x>= a);	
}
float bias(float b, float x)
{
	return pow(x, log(b)/log(0.5));
}
float gain(float g, float x) {
	if(x < 0.5)
		return bias(1.0-g, 2.0*x)/2.0;
	else
		return 1.0 - bias(1.0 -g, 2.0 - 2.0*x)/2.0;
}
#define PULSE(a,b,x) (step((a),(x)) - step((b),(x)))

/// brick from ebert et al "texturing and modeling"
#define BRICKWIDTH 2.25
#define BRICKHEIGHT 1.1
#define MORTAR    0.1
#define BMWIDTH  (BRICKWIDTH+MORTAR)
#define BMHEIGHT (BRICKHEIGHT+MORTAR)
#define MWF (MORTAR*0.5/BMWIDTH)
#define MHF (MORTAR*0.5/BMHEIGHT)

vec3 brick(vec2 pos) {
	float ss, tt, sbrick, tbrick,w,h;
	ss = pos.x / BMWIDTH;
	tt = pos.y / BMHEIGHT;
	
	if(mod(tt*0.5, 1.0) > 0.5){
		ss+=0.5;	
	}
	sbrick = floor(ss);
	tbrick = floor(tt);
	ss-=sbrick;
	tt-=tbrick;
	
	w = step(MWF,ss) - step(1.0-MWF, ss);
	h = step(MHF,tt) - step(1.0-MHF, tt);
	
	vec3 color1 = vec3(0.5,0.5,0.5);
	vec3 color2 = vec3(0.6, 0.15,0.1);
	
	vec3 color = mix(color1,color2, w*h);
	
	return color;
	
}
// noise from stegu and ashmima arts (copied from other examples in the gallery)
vec4 permute(vec4 u)
{
    return mod(u*(u*34.0 + 1.0), 289.0);
}

vec4 invsqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
{
    const vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

    vec3 i = floor(v + dot(v, C.yyy) );
    vec3 x0 = v - i + dot(i, C.xxx) ;
    
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy ); 

    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy;
    vec3 x3 = x0 - D.yyy;

    i = mod(i, 289.0); 
    vec4 p = permute( permute( permute(
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

    float n_ = 0.142857142857;
    vec3 ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ ); 

    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4( x.xy, y.xy );
    vec4 b1 = vec4( x.zw, y.zw );

    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

    vec3 p0 = vec3(a0.xy,h.x);
    vec3 p1 = vec3(a0.zw,h.y);
    vec3 p2 = vec3(a1.xy,h.z);
    vec3 p3 = vec3(a1.zw,h.w);

    vec4 norm = invsqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
                                dot(p2,x2), dot(p3,x3) ) );
}

vec4 dnoise(vec3 p)
{
    vec3 pi = floor(p);
    vec3 pf = fract(p);
    vec3 dp = 30.0 * pf * pf * (pf * (pf - vec3(2.0)) + vec3(1.0));

    pf = pf * pf * pf * (pf * (pf * 6.0 - vec3(15.0)) + vec3(10.0));

    float a = snoise(vec3(pi));
    float b = snoise(vec3(pi)+vec3(1.0,0.0,0.0));
    float c = snoise(vec3(pi)+vec3(0.0,1.0,0.0));
    float d = snoise(vec3(pi)+vec3(1.0,1.0,0.0));
    float e = snoise(vec3(pi)+vec3(0.0,0.0,1.0));
    float f = snoise(vec3(pi)+vec3(1.0,0.0,1.0));
    float g = snoise(vec3(pi)+vec3(0.0,1.0,1.0));
    float h = snoise(vec3(pi)+vec3(1.0,1.0,1.0));
    
    float k0 =   a;
    float k1 =   b - a;
    float k2 =   c - a;
    float k3 =   e - a;
    float k4 =   a - b - c + d;
    float k5 =   a - c - e + g;
    float k6 =   a - b - e + f;
    float k7 = - a + b + c - d + e - f - g + h;

    return vec4(k0 + k1*pf.x + k2*pf.y + k3*pf.z + k4*pf.x*pf.y + k5*pf.y*pf.z + k6*pf.z*pf.x + k7*pf.x*pf.y*pf.z,
                dp.x * (k1 + k4*pf.y + k6*pf.z + k7*pf.y*pf.z),
                dp.y * (k2 + k5*pf.z + k4*pf.x + k7*pf.z*pf.x),
                dp.z * (k3 + k6*pf.x + k5*pf.y + k7*pf.x*pf.y));
}

float fbm(vec3 pos, float gain, float lacunarity)
{
    float v = 0.0;
    float amplitude = 1.0;
    vec4 n;
    vec3 d = vec3(0.0);
    float s = 0.0;
    for(int i=0; i<4; i++)
    {
        n = dnoise(pos);
        d += n.yzw;
        v += n.x * amplitude / (1.0 + dot(d,d));
        pos *= lacunarity;
        s += amplitude / (1.0 + dot(d,d));
        amplitude *= gain;
    }
    return v/s;
}


float sdBox( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}
vec3 rotateY(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = ca*p.x + sa*p.z;
    r.y = p.y;
    r.z = -sa*p.x + ca*p.z;
    return r;
}

float repeat_boxes(vec3 p) {
	vec3 c = vec3(1.0, 10.0, 2.0);
	vec3 q = p;
	float displacement= sin(2.2*p.x)*sin(.202*p.y)*sin(0.20*p.z);
	float displacement2 = snoise(p*0.10*sin(time));
	q.xy = mod(p.xy, c.xy)-0.5*c.xy;
	q = rotateY(q, 3.14159265*45.0/180.0);

	float d = sdBox(q, vec3(1.4142, 2.50, 1.4142));

	return d+displacement+displacement2;
	//return d;
}
float wall(vec3 p) {
	float d = repeat_boxes(p);
	float d2 = repeat_boxes(p+vec3(1.4641, 5.0, 0.0));

	float constraints = sdBox(p, vec3(10.0,10.0,4.0));
	return max(constraints,min(d, d2));
}
vec2 scene(vec3 p){
	vec3 pry = rotateY(p, 0.5*PI);
	float d1 = wall(p+vec3(0.0, .0, 10.0));
	float d2 = wall(pry+vec3(0.0, .0, 10.0));
	
	
	return vec2(min(d1,d2), 0.9);
}
vec3 scene_color(vec3 p, float t){
	float intensity = 0.5*(1.0+(sin(t)));
	return vec3(1.0, 1.0, 1.0);
}
vec3 scene_pattern(vec3 p) {
	return brick(p.xy*5.0);
}




void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  float mx=mouse.x*PI*2.0;
  float my=mouse.y*PI/2.01;   
  vec3 prp=vrp+vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*20.0; //Trackball style camera pos

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=scene(p);
  }
  
  if (f<maxd){
    if (s.y==1.0) c=scene_color(p, time);
    n=normalize(
      vec3(s.x-scene(p-e.xyy).x,
           s.x-scene(p-e.yxy).x,
           s.x-scene(p-e.yyx).x));
    float b=dot(n,normalize(prp-p));
    vec3 pattern = scene_pattern(p);
    gl_FragColor=vec4((b*c*pattern+pow(b,8.0))*(1.0-f*.03),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0.0,0,1); //background color
}