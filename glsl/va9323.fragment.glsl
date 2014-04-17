// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.141592653589793

//burl figure modification
//rh2log.tumblr.com
//subtle_background_01

uniform float time;

void main()
{
	vec2 p=.005*gl_FragCoord.xy;
	for(int i=1;i<30;i++)
	{
		vec2 newp=p;
		newp.x+=(sin(time*0.03)*1.0+10.0)/float(i)*sin(float(i)+0.2*p.y+time/40.0+0.3*float(i+200))+400./2.0;		
		newp.y+=(cos(time*0.01)*0.5+1.6)/float(i)*sin(float(i)*p.x+time/40.0+0.3*float(i+30))-1400./40.0+15.0;
		p=newp;
	}
	vec3 c =vec3(cos(p.y+p.x-PI*vec3(0,2,6)/(20.0+0.2*sin(time)))*0.3+0.35)/1.7;
	c.r *= mod(gl_FragCoord.y, 2.0);
	c.g *= sin(c.r*1.5);
	c.b += sin(c.r*1.5);
	gl_FragColor=vec4(c*1.0, 1.0);
}
