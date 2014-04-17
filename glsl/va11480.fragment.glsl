#define v vec2
#define t time
#define s sin
#define u uniform
precision mediump float;u float t;u v mouse;u v resolution;
void main(){v p=(gl_FragCoord.xy/resolution.xy)+mouse/4.;
float c=0.;c+=s(p.x*cos(t/15.)*80.)+cos(p.y*cos(t/15.)*10.);
c+=s(p.y*s(t/10.)*40.)+cos(p.x*s(t/25.)*40.);c+=s(p.x*s(t/5.)*10.)+s(p.y*s(t/35.)*80.);
c*=s(t/10.)*.5;gl_FragColor=vec4(vec3(c,c*.5,s(c+t/3.)*.75),1.);}