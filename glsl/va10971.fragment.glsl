#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float kikaku(float x,float u)
{
	float x1=abs(x);
	float x2=x1/u;
	float x3=mod(x2,1.0);
	float x4=x3<0.5 ? x3 : 1.0-x3;
	return(x4);
}

float d2i(float dist)
{
	float r=0.05;
	float intensity = pow(r/dist, 2.0);
	return(intensity);
}


vec4 sankaku(vec2 pos)
{
	float r=0.7;
	float ux=r;
	float uy=r*1.7320508;
	float x4=kikaku(pos.x,ux);
	float y4=kikaku(pos.y,uy);
	if(x4+y4>0.5){
		x4=0.5-x4;
		y4=0.5-y4;
	}
	float d=length(vec2(x4*ux,y4*uy));	
	float i=d2i(d);
	return(vec4(1.0,1.0,1.0,1.0)*i);
}

vec2 o2n(vec2 v)
{
	float c=2.0;
	return vec2(
		(v.x*c-resolution.x)/resolution.y,
		(v.y*c-resolution.y)/resolution.y
		);
}


vec2 complex_mul(vec2 factorA, vec2 factorB){
  return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

void main( void )
{
	vec2 uv = gl_FragCoord.xy;
	vec2 c = resolution/2.;
	float w = -time*0.23;
	vec2 r = vec2(sin(w), cos(w));
	uv = c + complex_mul(uv - c, r)*1.;
	vec2 npos=o2n(uv);
	float l=length(npos);
	if(l<1.0)
	{
		float m=1.0/(1.0-l);
		gl_FragColor = sankaku(npos*m);
	
	}else{
		gl_FragColor = vec4(0.0,0.0,0.0,0.0);
	}
}