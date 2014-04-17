#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI=3.1415926535;
const float a=8.0*(PI-3.0)/(3.0*PI*(4.0-PI));

float erf_guts(float x)
{
	float x2=x*x;
	return exp(-x2*(4.0/PI+a*x2)/(1.0+a*x2));
}

float erf(float x)
{
	float sign=1.0;
	if (x<0.0) sign=-1.0;
	return sign*sqrt(1.0-erf_guts(x));
}

float blurredrectangle(vec2 pos,float radius,vec2 p1,vec2 p2)
{
	return (erf((pos.x-p1.x)/radius)-erf((pos.x-p2.x)/radius))*(erf((pos.y-p1.y)/radius)-erf((pos.y-p2.y)/radius))/4.0;
}

void main(void)
{
	vec2 position=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);

	float shadow=blurredrectangle(position,mouse.x/3.0,vec2(-0.5,-0.5),vec2(0.5,0.5));

	gl_FragColor=vec4(vec3(1.0-shadow),1.0);
}