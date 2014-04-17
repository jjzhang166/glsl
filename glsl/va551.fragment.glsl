#ifdef GL_ES
precision highp float;
#endif


// Cmen.
// disco apperu.
// No stalk. Just a big ball of bad phase plasma and interference skin/.


uniform vec2 resolution;
uniform float time;

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*18458.5453);
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
    float f = 0.0;

    f += 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

vec2 map( vec3 p )
{
   vec2 d2 = vec2( p.y+0.55, 2.0 );

   p.y -= 0.75*pow(dot(p.xz,p.xz),0.2);
   vec2 d1 = vec2( length(p) - 1.0, 1.0 );

   if( d2.x<d1.x) d1=d2;
   return d1;
}

float oa(vec3 q)
{
  vec3 t = vec3( mod(q.x,0.2)-0.1, mod(q.y,0.2)-0.1, mod(q.z,0.2)-0.1); 
  return sqrt(t.x*t.x+t.y*t.y+t.z*t.z);
}

vec3 disco(in vec2 p)
{
   vec3 org=vec3(cos(time*.01)*2.0,cos(time*.05)*2.0,cos(time*.05)),dir=normalize(vec3(p.y,p.x,.5)),q=org;

 float ca = cos(time/10.);
 float sa = sin(time/10.);
 vec3 tmp = dir; 
 dir.x = ca * tmp.x - sa * tmp.z; 
 dir.z = sa * tmp.x + ca * tmp.z; 

 dir /= 200.0;
 float steps = 0.0;

 for(int i=0;i<100;i++)
 {
  if ( oa(q) < 0.01) { steps += 0.5; }
  else
  q += dir;
  dir *= 1.04;
 }

 float f = steps*0.05;
 return vec3(tan(f),f*time*0.1,f*cos(time));
}


vec3 appleColor( in vec3 pos, in vec3 nor, out vec2 spe )
{
    spe.x = 1.0;
    spe.y = 1.0;

    float a = atan(pos.x,pos.z);
    float r = length(pos.xz);

    vec3 col = vec3(sin(nor.x / 0.25 + time + nor.y / 1.0),(sin(0.2 * time) * 0.5 - nor.x + 0.1) * (sin(0.8 * time) * .5 - nor.x + 0.5) + (cos(1.2 * time) * 0.5 - nor.y + 0.5) * (cos(r * time) * 0.5 - nor.y + 0.5),sin(nor.y / 0.25 + time + nor.z / 1.0));
float f = 1.0;
    // top
    f = 1.0-smoothstep( 0.14, 0.2, r );
    col = mix( col, vec3(0.6,0.6,0.5), f );
    spe.x *= 1.0-f;


    float ao = 0.5 + 0.5*nor.y;
    col *= ao*1.2;

    return col;
}

vec3 floorColor( in vec3 pos, in vec3 nor, out vec2 spe )
{
    spe.x = 1.0;
    spe.y = 1.0;
    
    vec3 col = vec3(sin(pos.x / 0.5 + time + pos.y / 1.0),sqrt(sin(0.5 * time) * 0.5 - pos.x + 0.5) * (sin(0.8 * time) * .5 - pos.x + 0.5) + (cos(1.2 * time) * 0.5 - pos.y + 0.5) * (cos(1.2 * time) * 0.5 - pos.y + 0.5),sin(pos.y / 0.25 + time + pos.z / 1.0))*1.7;

    //float f = fbm( 4.0*pos*vec3(6.0,0.0,0.5) );
    float f = 1.0;
    //col = mix( col, vec3(0.3,0.2,0.1)*1.7, f );
    //spe.y = 1.0 + 4.0*f;

    //f = fbm( 2.0*pos );
    //col *= 0.7+0.3*f;
    

    col -= disco(pos.xz);
    // fake ao
    f = smoothstep( 0.1, 1.55, length(pos.xz) );
    col *= f*f*1.4;
    col.x += 0.1*(1.0-f);
    return col;
}

vec2 intersect( in vec3 ro, in vec3 rd )
{
    float t=0.5;
    float dt = 0.06;
    float nh = 0.0;
    float lh = 0.0;
    float lm = -1.0;
    for(int i=0;i<100;i++)
    {
        vec2 ma = map(ro+rd*t);
        nh = ma.x;
        if(nh>0.0) { lh=nh; t+=dt;  } lm=ma.y;
    }

    if( nh>0.0 ) return vec2(-1.0);
    t = t - dt*nh/(nh-lh);

    return vec2(t,lm);
}

float softshadow( in vec3 ro, in vec3 rd, float mint, float maxt, float k )
{
    float res = 1.0;
    float dt = 0.1;
    float t = mint;
    for( int i=0; i<30; i++ )
    {
        float h = map(ro + rd*t).x;
        if( h>0.001 )
            res = min( res, k*h/t );
        else
            res = 0.0;
        t += dt;
    }
    return res;
}
vec3 calcNormal( in vec3 pos )
{
    vec3  eps = vec3(.001,0.0,0.0);
    vec3 nor;
    nor.x = map(pos+eps.xyy).x - map(pos-eps.xyy).x;
    nor.y = map(pos+eps.yxy).x - map(pos-eps.yxy).x;
    nor.z = map(pos+eps.yyx).x - map(pos-eps.yyx).x;
    return normalize(nor);
}


void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;

    // camera
    vec3 ro = 2.5*normalize(vec3(cos(0.2*time),1.15+0.4*cos(time*.11),sin(0.2*time)));
    vec3 ww = normalize(vec3(0.0,0.5,0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    // raymarch
    vec3 col = vec3(0.0);
    if (p.y > 0.0) {
    col = disco(p);
    }
    
    vec2 tmat = intersect(ro,rd);
    if( tmat.y>0.5 )
    {
        // geometry
        vec3 pos = ro + tmat.x*rd;
        vec3 nor = calcNormal(pos);
        vec3 ref = reflect(rd,nor);
        vec3 lig = normalize(vec3(1.0,0.8,-0.6));
     
        float con = 1.0;
        float amb = 0.5 + 0.5*nor.y;
        float dif = max(dot(nor,lig),0.0);
        float bac = max(0.2 + 0.8*dot(nor,vec3(-lig.x,lig.y,-lig.z)),0.0);
        float rim = pow(1.2+dot(nor,rd),3.0);
        float spe = pow(clamp(dot(lig,ref),0.0,1.0),16.0);

        // shadow
        float sh = softshadow( pos, lig, 0.06, 4.0, 4.0 );

        // lights
        col  = 0.10*con*vec3(0.80,0.90,1.00);
        col += 0.70*dif*vec3(1.00,0.97,0.85)*vec3(sh, (sh+sh*sh)*0.5, sh*sh );
        col += 0.15*bac*vec3(1.00,0.97,0.85);
        col += 0.20*amb*vec3(0.10,0.15,0.20);


        // color
        vec2 pro;
        if( tmat.y<1.5 )
        col *= appleColor(pos,nor,pro);
        else
        col *= floorColor(pos,nor,pro);

        // rim and spec
        col += 0.60*rim*vec3(1.0,0.97,0.85)*amb*amb;
        col += 0.60*pow(spe,pro.y)*vec3(1.0)*pro.x*sh;

        col = 0.3*col + 0.7*sqrt(col);
    }

    col *= 0.25 + 0.75*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.15 );

    gl_FragColor = vec4(col,1.0);
}