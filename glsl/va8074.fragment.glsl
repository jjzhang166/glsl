#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float Pi = 3.141592653589793;

// smooth colors by @hintz

void main()
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	
	for (int i=1;i<20;i++)
	{	
		p.x+=0.3/float(i)*sin(float(i)*p.y+time+0.3*float(i));
		p.y+=0.3/float(i)*cos(float(i)*p.x+time*1.01+0.3*float(i));
	}

	gl_FragColor=vec4(sin(p.x*Pi+time*0.99)+0.3, sin(p.y*Pi+time)+0.3, 0.5+sin(p.x+p.y+0.98*time), 1.0);
}