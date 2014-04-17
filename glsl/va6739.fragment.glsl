#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//frequency modulation graph thing, still learning
////freakuency modulation thingy, still hackin'

#define PI 3.14159

void main( void ) 
{

	vec2 pos = ( gl_FragCoord.yx / resolution.xy )-vec2(0.005,0.5);

	
	pos*=2.;
	float t=0.25*PI*pos.x;
	float s=sin(time)*(t+8.*mouse.x*cos(t*8.*time));
	float c=1.;
	
	if(pos.y-0.04>s||pos.y+0.04<s)
		{
		c=0.0;
		}

	vec2 pos2 = ( gl_FragCoord.xy / resolution.xy )-vec2(0.005,0.5);
	
	pos2*=2.;
	float t2=0.55*PI*pos2.x;
	float s2=cos(time)*(t+8.*mouse.x*cos(t*8.*time));
	float c2=1.;
	
	if(pos.y-0.04>s||pos2.y+0.04<s2)
		{
		c2=0.0;
		}
	
	
	gl_FragColor = vec4(c+c2);

}