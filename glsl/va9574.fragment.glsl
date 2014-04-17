#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


void main(void)
{    
 vec2 pos = 2.0 *( gl_FragCoord.xy / resolution.xy)- 1.0 ;
 pos.x*=resolution.x/resolution.y;
 pos=mod(abs(pos),vec2(1.,1.))-0.5;
 pos=vec2(pos.x*cos(time)-pos.y*sin(time),pos.x*sin(time)+pos.y*cos(time));
gl_FragColor =vec4(pos.x/dot(pos,pos)+pos.y/pos.x,  pos.y/dot(pos,pos), pow(pos.x*pos.y,0.3),1.);
 }
