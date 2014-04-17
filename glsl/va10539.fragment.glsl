#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float gear(vec2 p,vec2 at,float teeth,float size,float ang)
{
	p-=at;
	float v=0.0;
	float le=length(p);
	float w=le - 0.3 * size;
	v=w;
	w=sin(atan(p.y,p.x) * teeth + ang);
	w=smoothstep(-0.7,0.7,w) * 0.1;
	v=min(v,v - w);
	w=le-0.05;
	v=max(v, -w);
	return step(v,0.0);
}
void main()
{
	vec2 uv=gl_FragCoord.xy/resolution.xy;
	uv=uv*2.0-1.0;
	vec2 p=uv;
	p.x*=resolution.x/resolution.y;
	float w=gear(vec2(p.x,p.y)*0.54,vec2(0.0,0.0),8.0,1.0,time*8.0);
	gl_FragColor=vec4(w,w,w,1.0);
}