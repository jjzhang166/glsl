#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

const vec2 vR1=vec2(12.9898,78.233);
const float fR1=43758.5453;

float rand(const vec2 vSeed)
{
	return fract(sin(dot(vSeed,vR1))*fR1);
}

mat2 m = mat2( 0.80,  0.60, -0.60,  0.9 );

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

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

//Object A (tunnel)
float oa(vec3 q)
{
 
 return sin(q.z)+cos(q.x)+cos(q.y*2.0)+cos(q.z)+cos(q.y*1.)*.01;
}

//Scene
float o(vec3 q)
{
 return oa(q)+(fbm(q.xz)*0.5);
}

//Get Normal
vec3 gn(vec3 q)
{
 vec3 f=vec3(.01,0,0);
 return normalize(vec3(o(q+f.xyy),o(q+f.yxy),o(q+f.yyx)));
}

//MainLoop
void main(void)
{
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 vec4 c=vec4(1.0);
 vec3 org=vec3(sin(time)*.5,cos(time*.5)*.25+.25,time),dir=normalize(vec3(p.x*1.6,p.y,1.0)),q=org,pp;
	

 float d=.0;

 //First raymarching
	int aa=0;

for(int i=0;i<32;i++)
 {
  d=o(q);
	 if(d<0.0001) break;
  q+=d*dir;
	 aa++;
 }
 pp=q*cos(time*0.1);


 //Second raymarching (reflection)
 /*dir=reflect(dir,gn(q));
 q+=dir;
 for(int i=0;i<34;i++)
 {
 d=o(q);
 q+=d*dir;
 }*/

	
	
// c=max(dot(gn(q),vec3(.1,.1,.0)),.0)+vec4(.3,cos(time*.5)*.5+.5,sin(time*.5)*.5+.5,1.)*min(length(q-org)*.04,1.);


 //Final Color
 vec4 fcolor = vec4(0.5,1.0,1.0,1.0); //vec4(0.5,sin(time),cos(time),1.0);//((c)+(1.-min(pp.y+1.9,1.))*vec4(1.,.8,.7,1.))*min(time*.5,1.);
fcolor=mix(fcolor,vec4(fbm(pp.xy),fbm(pp.yx),1.0-fbm(q.yz),1.0),clamp(length(q),0.0,1.0))*0.8; //clamp(dir.z,0.0,1.0));
	fcolor=mix(fcolor*dir.z,vec4(0.0,0.0,0.0,1.0),float(aa)/64.0);
	gl_FragColor=vec4(fcolor.xyz,1.0);
}