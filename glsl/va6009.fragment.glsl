
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

void main(void)
{
    vec2 p = gl_FragCoord.xy / resolution.xy;
    float a = time*60.;
    float d,e,f,g=1.0/40.0,h,i,r,q;
    e=mouse.x*250.*(p.x*0.5+0.5);
    f=400.0*(p.y*0.5+0.5);
    i=abs(mouse.y*400.)+sin(e*g+a/150.0)*20.0;
    d=200.0+cos(f*g/2.0)*18.0+cos(e*g)*7.0;
    r=sqrt(pow(i-e,2.0)+pow(d-f,2.0));
    q=f/r;
    e=(r*cos(q))-a/2.0;f=(r*sin(q))-a/2.0;
    d=sin(e*g)*176.0+sin(e*g)*164.0+r;
    h=((f+d)+a/2.0)*g;
    i=cos(h+r*p.x/1.3)*(e+e+a)+cos(q*g*6.0)*(r+h/3.0);
    h=sin(f*g)*144.0+sin(e*g)*212.0*p.x;
    h=(h+(f-e)*q+sin(r-(a+h)/7.0)*10.0+i/4.0)*g;
    i+=cos(h*2.3*sin(a/350.0-q))*184.0*sin(q-(r*4.3+a/12.0)*g)+tan(r*g+h)*184.0*cos(r*g+h);
    i=mod(i/5.6,256.0)/64.0;
    if(i<0.0) i+=4.0;
    if(i>=2.0) i=4.0-i;
    d=r/350.0;
    d+=sin(d*d*10.0)*0.52;
    f=(sin(a*g)+mouse.y*10.)/2.0;
    gl_FragColor=vec4(vec3(f*i/1.6,i/2.0+d/13.0,i)*d*p.x+vec3(i/1.3+d/8.0,i/mouse.y+d/18.0,i)*d*(0.5-p.x),1.0);
}

    