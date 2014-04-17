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
	return(vec4(1.0,1.0,0.0,1.0)*i);
}

vec2 o2n(vec2 v)
{
	return vec2(
		(v.x*2.0-resolution.x)/resolution.y,
		(v.y*2.0-resolution.y)/resolution.y
		);
}



void main( void )
{
	vec2 npos=o2n(gl_FragCoord.xy);
	float l=length(npos);
	if(l<1.0)
	{
		float m=1.0/(1.0-1.0/l);
		gl_FragColor = sankaku(npos*m);
	
	}else{
		gl_FragColor = vec4(0.0,0.0,0.0,0.0);
	}
}