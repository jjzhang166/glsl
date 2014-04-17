#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


struct VR
{
    float m_v;
    bool  m_bRev;
};


VR kikaku(float x,float u)
{
	bool bRev=false;
	float x1=x;
	if(x1<0.0)
	{
	        x1= -x1;
        	bRev=!bRev;
	}
	float x2=x1/u;
	float x3=mod(x2,1.0);
	float x4=x3;
	if(x3>0.5)
	{
        	x3=1.0-x3;
        	bRev=!bRev;
    	}

	VR vr;    
	vr.m_v=x3;
	vr.m_bRev=bRev;
	return(vr);
}

float d2i(float dist)
{
	float r=0.05;
	float intensity = pow(r/dist, 2.0);
	return(intensity);
}


vec4 sankaku(vec2 pos)
{
	float r=0.5;
	float ux=r;
	float uy=r*1.7320508;
	VR x4=kikaku(pos.x,ux);
	VR y4=kikaku(pos.y,uy);
	if(x4.m_v<y4.m_v){
		y4.m_bRev=!y4.m_bRev;
	}

	if(y4.m_bRev){
		return(vec4(1.0,1.0,1.0,1.0));
	}else{
		return(vec4(0.0,0.0,0.0,1.0));
	}		
}

vec2 o2n(vec2 v)
{
	float c=2.5;
	return vec2(
		(v.x-resolution.x*0.5)*c/resolution.y,
		(v.y-resolution.y*0.5)*c/resolution.y
		);
}



void main( void )
{
	vec2 npos=o2n(gl_FragCoord.xy);
	float l=length(npos);
	if(l<1.0)
	{
		float m=1.0/(1.0-l);
		gl_FragColor = sankaku(npos*m+vec2(time*0.4,time*0.2));
	
	}else{
		gl_FragColor = sankaku(npos+vec2(time*0.4,time*0.2));
	}
}