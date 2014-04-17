// by @bermarte
#ifdef GL_ES
precision highp float;
#endif
uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;
//thanx Syntopia & Kali
float R =1.5,G=1.05,B=1.5;
float tt=cos(time/10.);
float JuliaX=1.05*mouse.x*tt*2.,JuliaY=-1.05*mouse.y*tt;
float C=1.;
vec2 c2 = vec2(JuliaX,JuliaY);

vec2 zkal(vec2 a) {
  float cx=2.;//change it
  float cy=4.;//idem
  float scale=3.;//idem
  a.x=abs(a.x);//remove if you want
  a.y=abs(a.y);//remove if you want
  if (a.x > 1.0) {a.x=2.-a.x;}
  if (a.y>1.0) {a.y=2.-a.y;}

float m=dot(a,a);
a.x=a.x/m*scale+cx;
a.y=a.y/m*scale+cy;

return a;
}

vec3 getColor2D(vec2 c) {
    bool Julia=true;
    vec2 z = Julia ?  c : vec2(0.0,0.0);  
    float mean = 0.0; 
    float PrItrs = 15.;
    const int iters=25;
    for (int i = 0; i < iters; i++) {// iters here is 12
       z = zkal(vec2(z))+(Julia ? c2 : c);
       if (float(i)>PrItrs) mean-=length(z);
  } 
    mean/=float(iters)-PrItrs;
    float co =   1.0 - log2(0.5+log2(mean/C));
    //change this
  return vec3( R+co,G+co,B+co);
//}
}

void main() {
  float aa1=14.;
  float aa2=aa1*2.;
    vec2 p = -aa1 + aa2 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x/resolution.y;
    vec3 col = vec3(0.0);
    col = getColor2D(vec2(p));
    gl_FragColor = vec4(col, 1.);
} 