// raymarching code stolen from @paulofalcao : http://glsl.heroku.com/e#15.5
// noise picked from Iq's eye O_o
// - e4r

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;


const int ITER = 20;
const float PI = 3.14159265;

float rand(vec3 co){
    return fract(sin(dot(co ,vec3(11.9898,78.233,51.5213))) * 43758.5453);
}

vec2 r2(vec2 v, float a) {
  mat2 m = mat2 (
		cos(a), -sin(a),
		sin(a), cos(a)
		);
  return m*v;
}

float ss(float mi,float ma,float f) { // sineSignal (min,max,alpha)
  float res;
	res = (sin(f)+1.)*(ma-mi)*0.5+mi;
  return res;
}

float ts(float mi, float ma,float l, float f ) {
  float res;
	res = mi + mod( f*(ma-mi/l),ma);
	return res;
}

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    //p = m*p*2.02; f += 0.03125*abs(noise( p ));	
    return f;
}
/*
 Simple raymarching sandbox
 Raymarching Distance Fields
 About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
 Also known as Sphere Tracing
*/


vec2 obj0(in vec3 p){
  float res = p.y+5.0;
	
  float d = ss(0.5,0.8,time);
  
  float pl = pow(length(p.xz)*0.3,d);	
  res-= pl;
	
  float res2= p.y-10.0;
  res2+= pl;
	
  res = min(-res2,res);	
  return vec2(res,0);
}

vec3 obj0_c(in vec3 p){
  vec3 res=vec3(1.,1.,1.);
  p.xz=r2(p.xz,time/5.);   
  
  float a = atan(p.z,p.x);
  float r = length(p.xz);
  res /=r*0.02 ;
  float d =3.; ss(2.0,2.2,time);
  float pl = sin(pow(length(p.xz)*0.15,d));
  res = mix(res, sin(a*15.+pl)*vec3(0.8,0.2,0.1),0.97);	

  res = abs(res);
	
  return res;

}

// ----------------------


 mat2 m2 = mat2( 0.80,  0.60, -0.60,  0.9 );

float hash2( float n )
{
    return fract(sin(n)*7919.0);//*
}

float noise2( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*7919.0;
    float res = mix(mix( hash(n+ 0.0), hash(n +1.0),f.x), mix( hash(n+ 7919.0), hash(n+ 7920.0),f.x),f.y);
    return res;
}

int mod(int a, int b) {
	return a - ((a / b) * b);
}

float fbm2( vec2 p ) {
    p*=3.;
    float f = 0.0;
        f += 0.25000*noise2( p ); p = m2*p*0.02;
        f += 0.12500*noise2( p ); p = m2*p*0.13;
        f += 0.06250*noise2( p ); p = m2*p*0.01;
        f += 0.03125*noise2( p ); p = m2*p*0.04;
        f += 0.01500*noise2( p );
    return f/0.38375;
}

vec2 r(vec2 v, float a) {
	mat2 m = mat2 (cos(a), -sin(a),
		       -sin(a), cos(a*a/20000.) );
	return m*v;
}


vec2 obj1(in vec3 p) {
  float s = 8.; // spacing
  float d = cos(p.x*0.05);
  float rs = 0.2 * time+ d; // rotating speed
  vec2 pos; // yz
  
  float a = rs+d;  
  
  pos = s*vec2( sin(a) , cos(a));

  float r = 1.5;
  float res;
	
//  res = ( ( length(p.yz+pos) -r ), 0.5 );  // cylinder
  float ss0 =  ss(0.,1.,p.y*2.);
	
  float w = fbm2(p.xy);	
  res = //length(p.yz+pos+w) -r ;	  
	( length(p.yz+pos+w*0.3*abs(p.x/10.)+sin(p.x/2.+time))-r ) - ss0 * sin(p.x+time);

  a = rs+PI*1.0+d;
  pos = s*vec2(sin(a),cos(a));
  float res2 = //length(p.yz+pos) -r ; 
  	( length(p.yz+pos+w*0.3*abs(p.x/10.)+sin(p.x/2.+time))-r ) - ss0 * sin(p.x+time);
	
  a = rs+PI*0.50+d;
  pos = s*vec2(sin(a),cos(a));
  float res3 = //length(p.yz+pos) -r ;
	  ( length(p.yz+w*0.3*abs(p.x/10.)+pos+sin(p.x/2.+time))-r ) - ss0 * sin(p.x+time);
	
  a = rs+PI*1.50+d;
  pos = s*vec2(sin(a),cos(a));
  float res4 = //length(p.yz+pos) -r ;
	  ( length(p.yz+pos+w*0.3*abs(p.x/10.)+sin(p.x/2.+time))-r ) - ss0 * sin(p.x+time);
	
	
  res = min(res,res4);
  res = min(res,res3);
  res = min(res,res2);
  return vec2(res,1.);
}

vec3 obj1_c(in vec3 p) {
  
  vec3 res = vec3(1.,0.2,0.) * 2.;

  float m = mod(sin(p.x),2.);
  float n = fbm(p);
  float g = fbm(vec3(p.x*time*2.,1.,1.))*2.;
  res = res*n*m*(g*2.+1.);
  return res;
}


// --------------------------- 
vec2 x(in vec3 p) {
  
  vec2 res;
  res.y = 3.; // color index	

  //size	
  const float r = 1.;
  
  // position
  vec3 op = vec3(
	  cos(time)*4.6,
	  sin(time)*2.,
	  1.);

  vec3 oSizes = vec3(1.,1.,1.);
 
  float roundBox =  length(max(abs(p)-oSizes,0.5))-r;
	
  res.x = (length(op-p)-r);
  //res += roundBox;

  return res;
}

vec3 x_c(in vec3 p) {
  vec3 res = vec3(0.8,0.2,0.1);
  res *= ss(0.0,5.,p.x*8.);
  return res;
}

// ---------------------------

vec2 ObjUnion(in vec2 obj0,in vec2 obj1){
  if (obj0.x<obj1.x)
  	return obj0;
  else
  	return obj1;
}

vec2 inObj(in vec3 p){
  vec2 res = vec2(99999999.,0.);
  //res = obj0(p); 
  res = ObjUnion(res,obj1(p)); 
  //res = ObjUnion(res,obj2(p)); 
  //res = ObjUnion(res,x(p));
  return res;
}


void main(void){
  vec3 bgColor = vec3 (0.1,0.0,0.0);
  //coords
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
  vec3 finalColor = vec3 (0.0);  
  
  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
	float s0 = ss(-15.,+15.,time*0.1);
	
  vec3 prp=vec3(s0,mouse.y*8.-4.,013.); //Change camera path position here
  vec3 vrp=vec3(sin(time*0.002)*2.,cos(time)*2.,0); //Change camere view here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=30.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<  ITER ; i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }

  if (f<maxd){
    if (s.y==0.0) c=obj0_c(p);
    else if (s.y==1.0) c=obj1_c(p);
    //else if (s.y==2.0) c=obj2_c(p);
    else if (s.y==3.0) c=x_c(p);

    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=dot(n,normalize(prp-p));

    vec3 finalColor = vec3( b*c+pow(b,8.0))*(1.0-f*.02) ;  //simple phong LightPosition=CameraPosition

	  //finalColor += s.x * vec3(0.1,0.2,0.3);
	  //finalColor += s.y * vec3(0.3,0.2,0.1);
	  //finalColor += n.z * vec3(0.6,0.2,0.2);
	  //finalColor += n.y * vec3(0.2,0.2,0.6);
	  //finalColor += n.x * vec3(0.1,0.0,0.1);
	  //finalColor += b * vec3(0.8,0.2,0.2);
	  finalColor/=3.;
	  
	  
     //vec4 old = texture2D(backbuffer, gl_FragCoord.xy);
     //finalColor = mix(finalColor, old.xyz, finalColor);
 
     gl_FragColor = vec4( finalColor, 1.);
  } else { // background
	   
     
     bgColor = 
	     //vec3(0.8,0.2,0.1)*1./f*100000.;
	  vec3(0.8,0.2,0.1);
	  
	  float n = fbm(p);
	  bgColor = bgColor * n * n *n*n/ f /f * 200000.;
	  //bgColor = bgColor *f/n * 0.00001 ;
	  gl_FragColor=vec4(bgColor,1.);
	  //gl_FragColor=vec4(bgColor,1.);
  }
}