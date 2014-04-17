#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float Pi = 3.14159;

void main()
{
	const float scale=0.02;
	const float scale2=200.0;
	const float timescale=0.03;
	const float timescale2=0.1;

	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	for(int i=0;i<50;i++)
	{
		vec2 newp=p;
		vec2 p2=p*160.0;

		
		float tx1=cos((time+float(i)*timescale)*3.0*timescale2)*scale2;
		float ty1=sin((time+float(i)*timescale)*3.0*timescale2)*scale2;
		float tx2=cos(-(time+float(i)*timescale)*2.0*timescale2)*scale2;
		float ty2=sin(-(time+float(i)*timescale)*2.0*timescale2)*scale2;
		float tx3=cos(-(time+float(i)*timescale)*2.0*timescale2)*scale2;
		float ty3=sin(-(time+float(i)*timescale)*2.0*timescale2)*scale2;
		newp.x+=sin((p2.y+ty1)/64.0/0.5*3.141592)*0.5*scale;
		newp.y-=cos((p2.x+tx1)/64.0/0.5*3.141592)*0.5*scale;
		newp.x+=sin((p2.y+ty2)/128.0/0.5*3.141592)*scale;
		newp.y-=cos((p2.x+tx2)/128.0/0.5*3.141592)*scale;
		newp.x+=sin((p2.y+ty3)/256.0/0.5*3.141592)*2.0*scale;
		newp.y-=cos((p2.x+tx3)/256.0/0.5*3.141592)*2.0*scale;
		p=newp;
	}
	p*=1.0;
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	gl_FragColor=vec4(col, 1.0);
}
