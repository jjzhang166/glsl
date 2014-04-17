// by @bermarte
#ifdef GL_ES
precision highp float;
#endif
uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;
//thanx Syntopia & Kali
float R =3.5,G=1.05,B=1.5*sin(time/10.);
float JuliaX=1.05*mouse.x,JuliaY=1.05*mouse.y*sin(time/10.);
//cx=-0.5, cy=-0.5 :
float C=14.;//*sin(time);
vec2 c2 = vec2(JuliaX,JuliaY);

vec2 zkal(vec2 a) {
    //longer version:
  a.x=abs(a.x-1.4);
  const float par=0.;
  a.y=-mod(a.y,par);//par > 0. is nice 2 (:
    float m=dot(a,a);
    a /=m;
    return a;
}

vec3 getColor2D(vec2 c) {
    bool Julia=true;
    vec2 z = Julia ?  c : vec2(1.0,0.0);  
    float mean = 0.0;
   
    float PrItrs = 14.;
    const int iters=34;
    for (int i = 0; i < iters; i++) {// iters here is 12
       z = zkal(vec2(z))+(Julia ? c2 : c);
       if (float(i)>PrItrs) mean-=length(z);
  } 
    mean/=float(iters)-PrItrs;
    float co =   1.0 - log2(0.5*log2(mean/C));
    //change this
    //return vec3( 0.5+.5*abs(0.00831*co+R),0.0057+.5*abs(5.0031*co + G),.5+0.5*abs(0.2831*co +B) );
  return vec3( R*co,G*co,B*co);
//}
}

void main() {
//here code mandelbrot
  float aa1=14.;
  float aa2=aa1*2.;
    vec2 p = -aa1 + aa2 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x/resolution.y;
  //p/=cos(time/100.*mouse.y);

    vec3 col = vec3(0.0);
    col = getColor2D(vec2(p));
    gl_FragColor = vec4(col, 1.);
} 