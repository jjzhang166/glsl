#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

void main(void)
{	
	vec2 p =8.0*( gl_FragCoord.xy / resolution.xy)-4.0;
	p.x*=resolution.x/resolution.y;
	for(int i=1;i<60;i++)
	
	{
	vec2 ti=vec2(cos(time/float(i*i*5)),tan(time/float(i*i)));
	p+=vec2(cos((p.y-ti.x))*sin(p.y-ti.x),sin(float(i)*0.1*cos(p.x-ti.y)))/sqrt(float(i)+abs(tan(time*0.1)));}
	gl_FragColor=vec4(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y), 1.0);
}