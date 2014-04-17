#ifdef GL_ES
precision highp float;
#endif

//test on IQ's distance functions : http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
// some mods by rotwang

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );


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




float sphere(vec3 p)
{
	return length(p)-5.;
}

float displacement(vec3 p)
{
	
	float k = fbm(p);
	k -= length(p.x *1.8 * sin(time));
	k -= length(p.y *.5 * sin(time/2.32));
	k -= length(p.z * 1.2 * cos(time/6.32));
	
	float kk = cos(p.x)*sin(k)*cos(p.z);
	float d = sqrt(kk)*sqrt(sin(p.x)*cos(k)*sin(p.z*k));
	return d*3.0;
}

float opDisplace( vec3 p )
{
	float d1 = sphere(p);
    	float d2 = displacement(p)*0.125;
    	return d1+d2;
}

void main(){

	vec2 p = -1. + 2.*gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
  vec3 vuv=vec3(0,1,0);
  vec3 vrp=vec3(0,1,0);
	float rt = time*0.15;
  vec3 prp=vec3(sin(rt)*8.0,4,cos(rt)*8.0);

  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+p.x*u+p.y*v;
  vec3 scp=normalize(scrCoord-prp);

  const vec3 e=vec3(0.1,0,0);
  const float maxd=16.0;

  float s=0.1;
  vec3 c,p1,n;

  float f=1.0;
  for(int i=0;i<16;i++){
    if (abs(s)<.01||f>maxd) break;
    f+=s;
    p1=prp+scp*f;
    s=opDisplace(p1);
  }
  
  if (f<maxd){
      c=vec3(1.0, 0.6,0.2);
    n=normalize(
      vec3(s-opDisplace(p1-e.xyy),
           s-opDisplace(p1-e.yxy),
           s-opDisplace(p1-e.yyx)));
	  vec3 p2 = p1;
	  p2.z *= -1.0;
	  vec3 c2=vec3(0.9, 0.69,0.19);
    float b1=dot(n,normalize(prp-p1));
	float b2=dot(n,normalize(prp-p2));  
	  vec3 clra = (b1*0.5*c2+pow(b1,256.0))*(2.0-f*.01);
	  vec3 clrb = (b2*0.5*c+pow(b2,24.0))*(1.0-f*.01);
	  vec3 clr = mix(clra,clrb, 0.5);
    gl_FragColor=vec4(clr,1.0);
  }
  else gl_FragColor=vec4(0,0,0,1);
}