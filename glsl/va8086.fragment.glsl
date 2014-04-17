#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

vec3 hsv_to_rgb(vec3 HSV)
{
	vec3 RGB; /* = HSV.z; */

	float h = HSV.x;
	float s = HSV.y;
	float v = HSV.z;

	h/=3.141592*2.0;
	h-=h;
	h*=6.0;
	
	float i = h;
	float f = h - i;

	float p = (1.0 - s);
	float q = (1.0 - s * f);
	float t = (1.0 - s * (1.0 - f));

	if (i == 0.0) { RGB = vec3(1.0, t, p); }
	else /* i == -1 */ { RGB = vec3(1.0, p, q); }

	RGB *= v;

	return RGB;
}

void main()
{
	vec2 op=2.0*(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	vec2 p=op;
	vec2 c=1.0*vec2(sin(time)-1.0,cos(time));
	for(int i=1;i<60;i++)
	{
		vec2 newp=vec2(
			p.x*p.x-p.y*p.y,
			2.0*p.x*p.y
		)+op;
		p=newp;
	}
	float r=length(p);
	float a=atan(p.y,p.x);
	vec3 col=hsv_to_rgb(vec3(a,0.5*sin(log(r)*10.0)+0.5,0.5*sin(6.0*a)+0.5));
	gl_FragColor=vec4(col, 1.0);
}
