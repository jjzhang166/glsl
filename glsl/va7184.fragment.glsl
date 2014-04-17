#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 resolution;

float ifsin;

void main(void) 
{	 

  float resy = 2.0 ;
	 
  float freq = 1.0+sin(gl_FragCoord.x*(time/50.0));
  float freq2 = 1.0*(0.5+sin(time*5.0)/2.0);
	
	if (abs(PI/2.0- ( ((resolution.x/4.0)-gl_FragCoord.y)/(1.0+10.0*resy*(0.5+0.5*sin(0.5+time*10.0*sin(gl_FragCoord.x)))*(0.75+0.25*sin(gl_FragCoord.x*freq2+time*20.0)))+PI/2.0) )<PI)
	{
		ifsin = 1.0;	
	}
	else
	{
		ifsin = 0.0;
	}
	
  float col = 0.5+sin(    ((resolution.x/4.0)-gl_FragCoord.y)/(10.0+10.0*resy*(0.5+0.5*sin(0.5+time*10.0*sin(gl_FragCoord.x)))*(0.75+0.25*sin(gl_FragCoord.x*freq2+time*20.0)))+PI/2.0); 
	
  vec4 finalcolor = vec4(ifsin,ifsin*col,0,1.0);
	
  float postfxedge = max(0.0,min(pow( 0.8+(1.0-(2.0*abs(0.5-(gl_FragCoord.x/resolution.x)))),20.0 ),1.0));
  float postfxstrips = min(0.5+max(sin(mod(((gl_FragCoord.x*1.0)-gl_FragCoord.y*1.0),1.9*PI)),0.0),1.0);
	
  gl_FragColor =  max(min(finalcolor*postfxstrips*postfxedge,1.0),0.0);
}