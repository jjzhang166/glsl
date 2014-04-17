#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;


vec2 map( vec3 p )
{
   vec2 d2 = vec2( p.y+0.55, 2.0 );

   p.y -= 0.75*pow(dot(p.xz,p.xz),0.2);
   vec2 d1 = vec2( length(p) - 1.0, 1.0 );

   if( d2.x<d1.x) d1=d2;
   return d1;
}


vec2 intersect( in vec3 ro, in vec3 rd )
{
    float t=0.0;
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
    vec3 ro = 2.5*normalize(vec3(cos(.52*time) + sin(p.x * 5.0 - time),1.15+0.4*cos(time*.11) - sin(p.y*4.0+sin(p.x + time + p.y)),sin(0.2*time) + p.x * 2.0 - sin(p.y)));
    vec3 ww = normalize(vec3(0.0,0.5,0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww - p.x * ww + sin(p.y * 4.0 - time) );

    // raymarch
    vec3 col = vec3(0.46,0.98,1.0);
    vec2 tmat = intersect(ro,rd);
        // geometry
        vec3 pos = ro + tmat.x*rd;
        vec3 nor = calcNormal(pos);
        vec3 lig = normalize(vec3(1.0,0.8,-0.6));
     
        float dif = max(dot(nor,lig)*0.5+0.5,0.0);


        // lights
        col  = 0.10*vec3(0.80,0.90,1.00);
        col += 0.70*dif*vec3(1.00,0.97,0.85);

    col *= 0.25 + 0.75*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.15 );

    gl_FragColor = vec4(col,1.0);
}