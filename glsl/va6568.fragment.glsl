#ifdef GL_ES
precision highp float; 
#endif

// Voltage Defame - Christmas 2012 

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

//Raymarching Distance Fields

mat2 m = mat2( 0.8,  0.6, -0.6,  0.6 );

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

float sdCone( vec3 p, vec2 c )
{
    // c must be normalized
    float q = length(p.xz);
    vec3 p1=p*4.5;
    vec3 p2=p*14.5;
	return dot(c,vec2(q,p.y))+(sin(p1.x)*sin(p1.y)*sin(p1.z))*.11+(sin(p2.x)*sin(p2.y)*sin(p2.z))*.06;
}

float sdTriPrism( vec3 p, vec2 n )
{
    vec3 q = abs(p);
    return max(q.z-n.y,max(q.x*0.866025+p.y*0.5,-p.y)-n.x*0.5);
}

vec2 ObjUnion(in vec2 obj_floor,in vec2 obj_roundBox){
  if (obj_floor.x<obj_roundBox.x)
  	return obj_floor;
  else
  	return obj_roundBox;
}

vec2 obj_floor(in vec3 p){
  return vec2(p.y+3.0+fbm(p.xz*0.07)*12.6,0);
}

vec2 fblob(vec3 p) {
	float d=sdCone(p-vec3(0,5,0),vec2(0.5,.15));
	float d1=sdCone((p-vec3(0,5,0)),vec2(0.56,.167));
	return vec2(max(d,-d1), 1);
}

//Floor Color (checkerboard)
vec3 obj_floor_c(in vec3 p){
     	return vec3(.81,.85,.81)-fbm(p.xz*2.7)*.2;
}

vec2 fStar(vec3 p)
{
	vec3 p1=p;
	p1.y-=5.2;
	p.y=-p.y;
	p.y+=5.2;
	float d=sdTriPrism(p1,vec2(.5,.02));
	float d1=sdTriPrism(p,vec2(.5,.02));
	return vec2(min(d,d1),2);
}

//Objects union
vec2 inObj(in vec3 p){
  vec3 p1=p;
	p1.x+=cos(p1.y*.42+time);
	return ObjUnion(ObjUnion(obj_floor(p),fblob(p1)),fStar(p1));
}

float ambientOcclusion(vec3 p, vec3 n) {
    float step = 0.2;
    float ao = 0.0;
    float dist;
    for (int i = 1; i <= 5; i++) {
        dist = step * float(i);
        ao += (dist - inObj(p + n * dist)) / float(i * i);
    }
    return ao;
}

void main(void){
  //Camera animation
  vec3 U=vec3(0,1,0);//Camera Up Vector
  vec3 viewDir=vec3(0,0,0); //Change camere view vector here
  vec3 E=vec3(-sin(time*.2)*8.0,4,cos(time/2.)*8.0); //Camera location; Change camera path position here
  //vec3 E=vec3(mouse.x*4.0, 4, mouse.y*4.0); //Camera location; Change camera path position here
	
  //Camera setup
  vec3 C=normalize(viewDir-E);
  vec3 A=cross(C, U);
  vec3 B=cross(A, C);
  vec3 M=(E+C);
  
  vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // (2*Sx-1) where Sx = x in screen space (between 0 and 1)
  vec3 scrCoord=M + vPos.x*A*resolution.x/resolution.y + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
  vec3 scp=normalize(scrCoord-E);

  //Raymarching
  const vec3 e=vec3(0.01,0,0);
  const float MAX_DEPTH=80.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>MAX_DEPTH) break;
    f+=s.x;
    p=E+scp*f;
    s=inObj(p);
	  s.x*=.7;
  }
  
  if (f<MAX_DEPTH){
    if (s.y==0.0)
      c=obj_floor_c(p);
    else
    {
    	if (s.y<1.5)
      		c=vec3(0.3,0.9,.3);
	else
      		c=vec3(1.2,1.2,0.8);
    }
		    
    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=max(dot(n,normalize(E-p)),.2);
    float ao=ambientOcclusion(p,n);
    gl_FragColor=vec4((c*b)+(f*.012)-vec3(ao),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(1,1,1,1); //background color
}