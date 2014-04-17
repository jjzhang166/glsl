// yates hack
// rotwang: @mod* lowered cam for better flight feeling
// @mod+ mouse y controls flight height
// @mod* some color tests
// @mod+ Canyon
// @emackey: Simple sky blue (no clouds...)
// @rotwang: mod* sky gradient, different terrain front and backcolor
// @mod* stripes texture
// @mod* terrain variation
#ifdef GL_ES
precision highp float;
#endif


uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024

//Util Start

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
   return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
   vec2 p = floor(x);
   vec2 f = fract(x);
   f = f*f*(3.0-2.0*f);
   float n = p.x + p.y*57.0;
   float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
   return res;
}

float fbm_5oct( vec2 p )
{
   float f = 0.0;
   f += 0.50000*noise( p ); p = m*p*2.02;
   f += 0.25000*noise( p ); p = m*p*2.03;
   f += 0.12500*noise( p ); p = m*p*2.01;
   f += 0.06250*noise( p ); p = m*p*2.04;
   f += 0.03125*noise( p );
   return f/0.984375;
}

float fbm_3oct( vec2 p )
{
   float f = 0.0;
   f += 0.50000*noise( p ); p = m*p*2.02;
   f += 0.25000*noise( p ); p = m*p*2.03;
   f += 0.12500*noise( p ); p = m*p*2.01;

   return f/1.5;
}

vec2 ObjUnion(in vec2 obj_floor,in vec2 obj_roundBox){
 if (obj_floor.x<obj_roundBox.x)
   return obj_floor;
 else
   return obj_roundBox;
}
//Util End

//Scene Start

vec2 terrain(in vec3 p){

 float da = 1.1*sin(0.9*p.y)*fbm_3oct( p.xz * (0.2 + time/100000.) );
   // vec2 vd = vec2(p.y+fbm_3oct( p.xz / 12.0 * 0.2 * time/900.) * 8.33 ,0);
 vec2 vd = vec2(p.y+fbm_3oct( p.xz / 12.0 * (0.01 + time/6200.) ) * 8.33 ,0);
 vd.x += da;

 return vd;
}

vec3 hsv2rgb(float h,float s,float v) {
 return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

/**
@rotwang:
smoothes between 2 vectors a and b (eg colors)
using a source value and a smooth amount
about the base as center.
*/
vec3 smoothmix(vec3 a, vec3 b, float base, float smooth, float source)
{
 float f = smoothstep(base-smooth, base+smooth, source );
 vec3 vec = mix(a, b, f);
 return vec;
}


//Terrain Color
vec3 terrain_clr(in vec3 p){


 vec3 clr_a = vec3(0.9, 0.9, 1.0);
 vec3 clr_b = vec3(0.0, 0.0, 0.0);
 float m = mouse.x;  // 0.0*mouse.y*fract(2.0);
 float g = fbm_3oct(p.xz * time/32000.);
 clr_b += g;
 vec3 clr =  smoothmix(clr_a, clr_b, 0.76, 0.3, m );
 clr = mix( clr, g*clr, 0.6+(cos(time/9.)+1.)*0.1 );


 return clr;
}

//Objects union
vec2 inObj(in vec3 p){
 return terrain(p);
}

//Scene End

void main(void){
 //Camera animation
 vec3 U=vec3(0,1,0);//Camera Up Vector

 float speed = time*3.2;
 float my =   mouse.y*40.0;
 float camy = -1.0+my;
 float tary = -3.14+my;
 vec3 E=vec3(speed, camy, 0);//vec3(-sin(time/4.0)*8.0,4,cos(time/4.0)*8.0); //Camera location; Change camera path position here
 vec3 viewDir=vec3(E.x-sin(mouse.x*1.0),tary,E.z+cos(mouse.x*1.0)); //Change camere view vector here
 //vec3 E=vec3(mouse.x*0.0, 4, mouse.y*4.0); //Camera location; Change camera path position here

 //Camera setup
 vec3 C=normalize(viewDir-E);
 vec3 A=cross(C, U);
 vec3 B=cross(A, C);
 vec3 M=(E+C);

 vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // (2*Sx-1) where Sx = x in screen space (between 0 and 1)
 vec3 scrCoord=M + vPos.x*A*resolution.x/resolution.y + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
 vec3 scp=normalize(scrCoord-E);

 //Raymarching
 const vec3 e=vec3(0.1,0,0);
 const float MAX_DEPTH=100.0; //Max depth

 vec2 s=vec2(0.1,0.0);
 vec3 c,p,n;

 float f=1.0;
 for(int i=0;i<5;i++){
   if (abs(s.x)<.01||f>MAX_DEPTH) break;
   f+=s.x;
   p=E+scp*f;
   s=inObj(p);
 }

 if (s.y==0.0) c=terrain_clr(p);
 vec3 cc = vec3(c.r, c.g, c.b);

 float m = smoothstep(3.0, 20.0, f);
 c = mix(c, cc, 1.0-m);

 n=normalize(
   vec3(s.x-inObj(p-e.xyy).x,
        s.x-inObj(p-e.yxy).x,
        s.x-inObj(p-e.yyx).x));
 float b=dot(n,normalize(E-p));
 gl_FragColor=vec4(b*c*(2.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
}