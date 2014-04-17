#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

float f( vec3 p )
{
    return length(max(abs(p)-vec3(.7),0.0))-.3;
}

vec3 calcNormal(in vec3 pos)
{
    vec3  eps = vec3(.001,0.0,0.0);
    vec3 nor;
    nor.x = f(pos+eps.xyy) - f(pos-eps.xyy);
    nor.y = f(pos+eps.yxy) - f(pos-eps.yxy);
    nor.z = f(pos+eps.yyx) - f(pos-eps.yyx);
    return normalize(nor);
}


vec2 intersect(vec3 ro, vec3 rd)
{
    float t = 0.0;
    for(int i=0;i<64;i++)
    {
       float h = f(ro + rd*t);
        if( h<0.002 ) 
            return vec2(t,h);
        t += h;
    }

}

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x/resolution.y;
	
    // light
    vec3 light = normalize(vec3(1.0,0.8,-0.6));

    float ctime = time;
    // camera
    vec3 ro = 1.1*vec3(2.5*cos(0.5*ctime),1.5*cos(ctime*.23),2.5*sin(0.5*ctime));
    vec3 ww = normalize(vec3(0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    vec3 col = vec3(.7,.5,.3);
    vec2 d = intersect(ro,rd);
    if( d.y < 1.)
    {
       vec3 P = ro + d.x*rd;
       vec3 N = calcNormal(P);
       vec3 L = normalize(light - P);
       vec3 V = normalize(-rd);
       vec3 R = reflect(L,N);
       vec3 H = normalize(L+V);

       col =  vec3(0.7, 0.11, 0.13) * clamp(dot(N,L),.001,.9) + vec3(0.29, 0.31, 0.33) * (37.+2.)/6.*pow(clamp(dot(H,L),.01,.99),37.); 
    }

    gl_FragColor = vec4(col,1.);
}