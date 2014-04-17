#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


mat3 m = mat3( 0.00,  0.80,  0.60,
              0.10,  0.66, -0.48,
              -0.50, -0.68,  0.64 );

float hash( float n )
{
    return fract(sin(n)*758.5453);
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 68.0),f.x),f.y),
                    mix(mix( hash(n+313.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.y);
    return res;
}

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*5.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    //p = m*p*2.02; f += 0.03125*abs(noise( p ));	
    return f;
}



float sphere(vec3 p)
{
	return length(p)-5.;
}

float displacement(vec3 p)
{
	return sin(p.y*4.0)*3.0*sin(p.z*4.0-time*8.0)/8.0;
}

float obj( vec3 p )
{
	float d1 = sphere(p);
    	float d2 = displacement(p);
    	return d1+d2;
}

vec3 obj_c( vec3 p ){
	return vec3(.9,0.2,0.9);
}
	
void main( void ) {
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here 
  vec3 prp=vec3(sin(time)*5.0,4,cos(time)*6.0);
	
  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const float maxd=60.0; //Max depth
  const vec2 e=vec2(0.01,-0.01);
  float s=0.1;
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<32;i++){
    if (abs(s)<e.x||f>maxd) break;
    f+=s;
    p=prp+scp*f;
    s=obj(p);
  }
  
  if (f<maxd){
    c=obj_c(p);
    vec4 v=vec4(
	    obj(vec3(p+e.xyy)),obj(vec3(p+e.yyx)),
	    obj(vec3(p+e.yxy)),obj(vec3(p+e.xxx)));
    n=normalize(vec3(v.w+v.x-v.z-v.y,v.z+v.w-v.x-v.y,v.y+v.w-v.z-v.x));
    float b=dot(n,normalize(prp-p));
vec3 col = (b*c+pow(b,200.0))*(1.0-f*.08);
          float red = fbm(col.rrr);
          float green = fbm(col.ggg);
          float blue = fbm(col.bbb);
	  vec3 col2 = vec3(red,green,blue);
	  gl_FragColor=vec4(col2 * 1.7 + .1,0.0);
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}