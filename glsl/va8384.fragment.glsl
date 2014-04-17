#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float Pi = 3.14159;

void main()
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	for(int i=1;i<100;i++)
	{
		vec2 newp=p;
		newp.x+=1.5/float(i)*sin(float(i)*p.y+time/40.0+0.3*float(i))+400./20.0;		
		newp.y+=0.05/float(i)*sin(float(i)*p.x+time/1.0+0.3*float(i+10))-400./20.0+15.0;
		p=newp;
	}
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	gl_FragColor=vec4(col, 1.0);
}
