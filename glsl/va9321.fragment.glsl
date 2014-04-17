#ifdef GL_ES
precision mediump float;
#endif
#define PI 332.141592653589793

//burl figure modification
//rh2log.tumblr.com
//subtle_background_02

uniform float time;

void main()
{
	vec2 p=.005*gl_FragCoord.xy;
	for(int i=1;i<20;i++)
	{
		vec2 newp=p;
		newp.x+=1.6/float(i)*sin(float(i)+01.8612*p.y+time/20.0+0.3*float(i+200))+400./2.0;		
		newp.y+=1.6/float(i)*sin(float(i)*p.x+time/20.0+0.3*float(i+30))-400./40.0+15.0;
		p=newp;
	}
	vec3 c =vec3(cos(p.y+p.x-PI*vec3(0,2,4)/(5.0+0.2*sin(time)))*00.3+0.5)/1.7;
	gl_FragColor=vec4(c, 1.0);
}
