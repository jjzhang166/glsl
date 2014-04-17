#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Shabtonic - some neat mouse cogs :)
// u can make the cog teeth overlap by drawing 4 sets of cogs with a gap e.t.c. too lazy for that tho :P
// Scagged from the earlier version of the COG

float Cog(vec2 p,float t)
{

vec2 rp=floor((p+100.0)/200.0)-100.0;
t=t*((floor(mod(rp.x+rp.y,2.0))-0.5)*2.0);
p=mod(p+100.0,200.0)-100.0;

float angle = atan(p.x, p.y);  
float scale = 0.0001; 
float distance = 1.05 - scale * ((p.x * p.x) + (p.y * p.y)); 
float cogMin = 0.02;
float cogMax = 0.7; 
float toothAdjust = 2.4 * (distance - cogMin); 
float angleFoo = sin(angle*20.0 - t * 4.0) - toothAdjust; 
cogMin += 20.0 * clamp(1.0 * (angleFoo + 0.2), 0.0, 0.015);
float isSolid = clamp(1.0 * (distance - cogMin) / cogMax, 0.0, 1.0); 
isSolid = clamp(isSolid * 100.0 * (cogMax - distance), 0.0, 1.0); 
return isSolid;
}

void main( void ) 
{ 
vec2 p1 = ((gl_FragCoord.xy / resolution.xy) - mouse*0.125)*resolution; 
vec2 p2 = ((gl_FragCoord.xy / resolution.xy) - mouse*0.25)*resolution; 
vec2 p3 = ((gl_FragCoord.xy / resolution.xy) - mouse*0.5)*resolution; 
vec2 p4 = ((gl_FragCoord.xy / resolution.xy) - mouse*1.0)*resolution; 
float col=max(Cog(((p1+50.0)/2.0),time*3.0)*0.2,Cog((p2+100.0),time)*0.4);
col=max(col,Cog(((p3+100.0)*2.0),time*8.0)*0.26);
col=max(col,Cog(((p4+100.0)*6.0),time*8.0)*0.25);
gl_FragColor = vec4(0.2*col,0.1*col,0,1.0); 
}

