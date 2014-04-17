// Kong
//
// CIS 565 hackathon at the University of Pennsylvania - http://www.seas.upenn.edu/~cis565

//third party code
// noise library
// ray matching http://mrdoob.com/projects/glsl_sandbox/#A/
// http://glsl.heroku.com/e#5073.1

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backBuffer;

vec4 live = vec4(0.0,0.5,0.1,1.0);
vec4 dead = vec4(0.0,0.0,0.0,1.0);
vec4 nextGeneration = vec4(1.0,0.5,0.1,1.0);
vec4 kill=vec4(1.0,0.0,0.0,1.0);


float rad=0.03;
float period=1.0;
vec2 pixel = 1.0/resolution;
vec4 buildingColor= vec4(0.4,0.0,0.0,1.0);

float snoise(vec2 v);
float snoise(vec3 v);
float snoise(vec4 v);
vec2 cellular(vec2 P);


vec2 obj1(in vec3 p){
  return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

vec2 opRep(in vec3 p )
{
    vec3 c = vec3(5.0,10.0,0.0);
    //vec3 q = mod(p,c)-0.5*c;
    vec3 q=p;
    q.x= mod(p.x,c.x)-0.5*c.x;
    q.y= mod(p.y,c.y)-0.5*c.y;
    //q.z= mod(p.z,c.z)-0.5*c.z;

    return obj1( q );
}


void main( void ) {

   vec2 position =  (gl_FragCoord.xy / resolution.xy );
	
   int frame=int(time/period);
   float res = time- float (frame) *period;
   vec4 current = texture2D(backBuffer, position);
	
	
  //Camera animation
  vec3 vuv=vec3(1,0,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  vec3 prp=vec3(0.0,0.0,20.0); //Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec2 newPos=-1.0+2.0*position;
  vec3 scrCoord=vcv+newPos.x*u*resolution.x/resolution.y+newPos.y*v;
	
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    //if (abs(s.x)<0.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=opRep(p);
  }
  
  if (f<maxd){
      gl_FragColor=buildingColor;
  }
	else{	
	
	if(abs(res-period*0.5)<0.01){
		float sum = 0.0;
		sum += texture2D(backBuffer, position + pixel * vec2(-1., -1.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(-1., 0.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(-1., 1.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(1., -1.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(1., 0.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(1., 1.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(0., -1.)).g;
		sum += texture2D(backBuffer, position + pixel * vec2(0., 1.)).g;
	
	
		if (current.g < 0.1) {
			if ((sum >= 0.3)) {
				gl_FragColor = live;
			} else{
				float rnd1 = snoise( vec3(position, time * 0.01) * 30.0);
				if (rnd1 > 0.9) {
					gl_FragColor = live;
				}
				
				//float rnd2 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
				//if (rnd2 > 2.0) {
					//gl_FragColor = live;
				//} else {
					//gl_FragColor = dead;
				//}
				
				
		}
			
			
		} else {
			if(sum<0.2)
				gl_FragColor =dead;
			if ((sum >= 0.2) && (sum <= 0.3)) {
				gl_FragColor = nextGeneration;
			} else if (sum>0.3){
				gl_FragColor = dead;
			}
		}
			
		
	 
	       
	
	}else{
		gl_FragColor=current;
	}

	if(length(position-mouse)<rad){
		if(current.g>0.09)
			gl_FragColor=kill;
	}
	
}

//gl_FragColor=vec4(vec3(0.0),1.0);
	
}

vec4 _mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 _mod289(vec3 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 _mod289(vec2 x) 
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float _mod289(float x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
  
vec4 _permute(vec4 x)
{
    return _mod289(((x*34.0)+1.0)*x);
}

vec3 _permute(vec3 x)
{
    return _mod289(((x*34.0)+1.0)*x);
}

float _permute(float x) 
{
    return _mod289(((x*34.0)+1.0)*x);
}

vec4 _taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float _taylorInvSqrt(float r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

vec4 _grad4(float j, vec4 ip)
{
    const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
    vec4 p,s;

    p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
    p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
    s = vec4(lessThan(p, vec4(0.0)));
    p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

    return p;
}
  

float snoise(vec3 v)
{ 
    const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

    // First corner
    vec3 i  = floor(v + dot(v, C.yyy) );
    vec3 x0 =   v - i + dot(i, C.xxx) ;

    // Other corners
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy );

    //   x0 = x0 - 0.0 + 0.0 * C.xxx;
    //   x1 = x0 - i1  + 1.0 * C.xxx;
    //   x2 = x0 - i2  + 2.0 * C.xxx;
    //   x3 = x0 - 1.0 + 3.0 * C.xxx;
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
    vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

    // Permutations
    i = _mod289(i); 
    vec4 p = _permute( _permute( _permute( 
                i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
              + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
              + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float n_ = 0.142857142857; // 1.0/7.0
    vec3  ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4( x.xy, y.xy );
    vec4 b1 = vec4( x.zw, y.zw );

    //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
    //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

    vec3 p0 = vec3(a0.xy,h.x);
    vec3 p1 = vec3(a0.zw,h.y);
    vec3 p2 = vec3(a1.xy,h.z);
    vec3 p3 = vec3(a1.zw,h.w);

    //Normalise gradients
    vec4 norm = _taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    // Mix final noise value
    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                dot(p2,x2), dot(p3,x3) ) );
}


