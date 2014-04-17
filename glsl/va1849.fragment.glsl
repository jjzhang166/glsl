    #ifdef GL_ES
    precision highp float;
    #endif
   
// Metaspikeballs

    uniform vec2 resolution;
    uniform float time;
    uniform sampler2D tex0;

    float sphere(in vec3 p, float r){
      return length(p)-r;
    }
     
    float opU(float obj0, float obj1){
      return min(obj0, obj1);
    }

    float impulse(float k, float x)
    {
      float h = k*x;
      return h*exp(1.0-h);
    }


    float opBlend(float d1, float d2) { 
      float dd = 1.;
      return mix(d1, d2, dd);
    }

    vec3 opRep( vec3 p, vec3 c )
    {
      vec3 q = mod(p,c)-0.5*c;
      return q;
    }
     
    float plane(in vec3 p, float h){
      return p.y+h;
    }
     
    vec3 hsv(float h,float s,float v) {
      return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
    }

    float sdTorus( vec3 p, vec2 t )
    {
      vec2 q = vec2(length(p.xz)-t.x,p.y);
      return length(q)-t.y;
    }
    
    float box(vec3 p, vec3 b)
    {
      return length(max(abs(p)-b,0.0));
    }

    float rbox( vec3 p, vec3 b, float r )
    {
      return length(max(abs(p)-b,0.0))-r;
    }

vec3 n1 = vec3(1.000,0.000,0.000);
vec3 n2 = vec3(0.000,1.000,0.000);
vec3 n3 = vec3(0.000,0.000,1.000);
vec3 n4 = vec3(0.577,0.577,0.577);
vec3 n5 = vec3(-0.577,0.577,0.577);
vec3 n6 = vec3(0.577,-0.577,0.577);
vec3 n7 = vec3(0.577,0.577,-0.577);
vec3 n8 = vec3(0.000,0.357,0.934);
vec3 n9 = vec3(0.000,-0.357,0.934);
vec3 n10 = vec3(0.934,0.000,0.357);
vec3 n11 = vec3(-0.934,0.000,0.357);
vec3 n12 = vec3(0.357,0.934,0.000);
vec3 n13 = vec3(-0.357,0.934,0.000);
vec3 n14 = vec3(0.000,0.851,0.526);
vec3 n15 = vec3(0.000,-0.851,0.526);
vec3 n16 = vec3(0.526,0.000,0.851);
vec3 n17 = vec3(-0.526,0.000,0.851);
vec3 n18 = vec3(0.851,0.526,0.000);
vec3 n19 = vec3(-0.851,0.526,0.000);

float spikeball(vec3 p) {
   vec3 q=p;
   p = normalize(p);
   vec4 b = max(max(max(
      abs(vec4(dot(p,n16), dot(p,n17),dot(p, n18), dot(p,n19))),
      abs(vec4(dot(p,n12), dot(p,n13), dot(p, n14), dot(p,n15)))),
      abs(vec4(dot(p,n8), dot(p,n9), dot(p, n10), dot(p,n11)))),
      abs(vec4(dot(p,n4), dot(p,n5), dot(p, n6), dot(p,n7))));
   b.xy = max(b.xy, b.zw);
   b.x = pow(max(b.x, b.y), 90.);
   return length(q)-2.5*pow(1.7,b.x*(1.-mix(.3, 1., sin(time*2.)*.5+.5)*b.x));
}
     
    //OBJ
    vec4 inObj(in vec3 p){
      float o = spikeball(opRep(p, vec3(16.)));
      //float o2 = sphere(p + vec3(sin(time)*8.0, 0, cos(time*.5)*16.0), 16.0);
      float o3 = spikeball(p/2.0+ vec3(cos(time)*4.0, sin(time)*8.0, cos(time*.9541)*5.0));
      float srf = 1.0/(1.0/(o+1.0)+1.0/(o3))-1.0;
      
      return vec4(srf, hsv(p.x*.1+time*.1,1.,1.)+hsv(p.y*.2+time*.3,1.,1.)-hsv(p.z*.3+time*.2,1.,1.));
    }
     
    //SCENE END
     
    void main(void){
      vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
     
      //Camera animation
      vec3 vuv=vec3(sin(time/2.),1,sin(time/2.123242));//view up vector
      vec3 vrp=vec3(0); //view reference point
      vec3 prp=vec3(sin(time*.5)*25.0,sin(time*.2)*24.0,cos(time*.3)*34.0); //camera position
     float vpd=1.5; 
      //Camera setup
      vec3 vpn=normalize(vrp-prp);
      vec3 u=normalize(cross(vuv,vpn));
      vec3 v=cross(vpn,u);
      vec3 vcv=(prp+vpn);
      vec3 scrCoord=prp+vpn*vpd+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
      vec3 scp=normalize(scrCoord-prp);
     
      //Raymarching
      const vec3 e=vec3(0.1,0,0);
      const float maxd=100.0;
     
      vec4 s=vec4(0.1, 0, 0, 0);
      vec3 c,p,n;
     
      float f=1.0;
      for(int i=0;i<256;i++){
        if (abs(s.x)<.01||f>maxd) break;
        f+=s.x;
        p=prp+scp*f;
        s=inObj(p);
      }
     
      if (f<maxd){
        c = s.yzw;
        n=normalize(
          vec3(s.x-inObj(p-e.xyy).x,
               s.x-inObj(p-e.yxy).x,
               s.x-inObj(p-e.yyx).x));
        float b=dot(n,normalize(prp-p));
        gl_FragColor=vec4((b*c+pow(b,54.0))*(1.0-f*.01),1.0);
      }
      else gl_FragColor=vec4(0,0,0,1);
    }