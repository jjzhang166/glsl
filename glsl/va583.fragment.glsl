// by @bermarte
#ifdef GL_ES
precision highp float;
#endif
uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;
//thanx Syntopia & Kali
float R =0.5,G=1.05,B=1.5;
float JuliaX=-0.5*mouse.x,JuliaY=-0.5*mouse.y;
//cx=-0.5, cy=-0.5 :
float C=14.*sin(time);
vec2 c2 = vec2(JuliaX,JuliaY);

vec2 zkal(vec2 a) {
    //longer version:
    //a.x=abs(a.x);
    //a.y=abs(a.y);
    //float m;
    //m=a.x*a.x+a.y*a.y;
    //a.x=a.x/m;
    //a.y=a.y/m;
    a=abs(a);
    float m=dot(a,a);
    a /=m;
    return a;
}

vec3 getColor2D(vec2 c) {
    bool Julia=true;
    vec2 z = Julia ?  c : vec2(0.0,0.0);  
    float mean = 0.0;
    float dist = 10000.0;
    float PrItrs = 4.;
    const int iters=44;
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
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x/resolution.y;
  p/=sin(time/100.-mouse.y);

    vec3 col = vec3(0.0);
    col = getColor2D(vec2(p));
    gl_FragColor = vec4(col, 1.);
} 