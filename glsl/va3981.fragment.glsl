#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi=3.1415926535;

vec2 clog(vec2 v)
{
	return vec2(log(sqrt(v.x*v.x+v.y*v.y)),atan(-v.y,v.x));
}

vec4 checkerboard(vec2 pos)
{
	float a=(fract(pos.x)-0.5)*(fract(pos.y)-0.5);
	if(a>0.0) return vec4(0.7,0.72,0.7,1.0);
	else return vec4(0.3,0.33,0.3,1.0);
}

vec4 grid(vec2 pos,float thickness)
{
	vec2 a=abs(fract(pos)-0.5);
	if(a.x>thickness && a.y>thickness) return vec4(0.7,0.72,0.7,1.0);
	else return vec4(0.3,0.33,0.3,1.0);
}

void main()
{
	vec2 position=2.0*(gl_FragCoord.xy/resolution.xy)-1.0;

	const float p1=1.0;
	const float p2=1.0;
	float u_corner=2.0*pi*p2;
	float v_corner=log(256.0)*p1;
	float diag=sqrt(u_corner*u_corner+v_corner*v_corner);
	float sin_a=v_corner/diag;
	float cos_a=u_corner/diag;
	float scale=diag/2.0/pi;

	vec2 p=clog(position);

	vec2 rotated=vec2(p.x*cos_a-p.y*sin_a,
		          p.x*sin_a+p.y*cos_a);
	vec2 scaled=rotated*scale/vec2(log(256.0),2.0*pi);
	vec2 translated=scaled-vec2(0.35+time*0.1,0.0);
	
//	gl_FragColor=checkerboard(translated*2.0);
	gl_FragColor=grid(translated*8.0,0.1);
}
