#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float white=0.7;
float black=0.3;
vec2 size=resolution;
float scale=1.0;


void main()
	for(int i=1;i<=10;i++)
	{
		vec2 newpos=pos+100.0/float(i)*vec2(cos(float(i)*pos.y/50.0+10.0*sin(time/1.0)),sin(float(i)*pos.x/50.0+10.0*cos(time/1.0)));
		pos=newpos;
	}
	vec2 gridpos=fract(pos/32.0)-vec2(0.5);
	if(gridpos.x*gridpos.y>0.0) gl_FragColor=vec4(vec3(white),1.0);
	else gl_FragColor=vec4(vec3(black),1.0);
}

