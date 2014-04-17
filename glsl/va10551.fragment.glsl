#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi=3.1415926535;

float white=0.7;
float black=0.1;
vec2 size=resolution;
float scale=1.0;

const int num=5;

float wave(vec2 pos,float angle,float wavelength,float phase)
{
	return sin(dot(pos,vec2(cos(angle),sin(angle)))*2.0*pi/wavelength+phase);
}

void main()
{
	vec2 pos=gl_FragCoord.xy/scale-size/2.0;

	float amp=0.0;
	for(int i=0;i<num;i++)
	{
		float angle=float(3*i)*pi/float(num);
		amp+=wave(pos,angle,60.0,time);
	}

	float y=gl_FragCoord.y/mouse.x;
	
	float c=sin(pi*12.0*(amp+float(num))/float(num)/2.0);
	c=clamp(c,0.0,1.0);
	c=pow(c,0.3);
	c=black+(white-black)*(c+y)*0.2;
	//gl_FragColor=vec4(vec3(c),1.0);
	gl_FragColor=vec4(vec3(amp),1.0);
}
