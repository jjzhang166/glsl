#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float distfunc(vec3 pos)
{
//	pos-=floor(pos);
	pos-=3.141592/2.0;

	return (sin(pos.x)+sin(pos.y)+sin(pos.z))*0.4-0.1+0.15*pos.y;
}

vec3 palette(float i)
{
	if(i<4.0)
	{
		if(i<2.0)
		{
			if(i<1.0) return vec3(0.0,0.0,0.0);
			else return vec3(1.0,3.0,31.0);
		}
		else
		{
			if(i<3.0) return vec3(1.0,3.0,53.0);
			else return vec3(28.0,2.0,78.0);
		}
	}
	else if(i<8.0)
	{
		if(i<6.0)
		{
			if(i<5.0) return vec3(80.0,2.0,110.0);
			else return vec3(143.0,3.0,133.0);
		}
		else
		{
			if(i<7.0) return vec3(181.0,3.0,103.0);
			else return vec3(229.0,3.0,46.0);
		}
	}
	else
	{
		if(i<10.0)
		{
			if(i<9.0) return vec3(252.0,73.0,31.0);
			else return vec3(253.0,173.0,81.0);
		}
		else if(i<12.0)
		{
			if(i<11.0) return vec3(254.0,244.0,139.0);
			else return vec3(239.0,254.0,203.0);
		}
		else
		{
			return vec3(242.0,255.0,236.0);
		}
	}
}


vec4 colour(float c)
{
	c*=12.0;
	vec3 col1=palette(c)/256.0;
	vec3 col2=palette(c+1.0)/256.0;
	return vec4(mix(col1,col2,c-floor(c)),1.0);
}

void main()
{
	vec2 coords=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);

	vec3 ray_dir=normalize(vec3(coords,1.0+1.0*sqrt(coords.x*coords.x+coords.y*coords.y)));
	vec3 ray_orig=vec3(0.0,0.0,time*10.0);

	float a=time*0.4;
	ray_dir=ray_dir*mat3(
		cos(a),sin(a),sin(a),
		-sin(a),cos(a),0.0,
		0.0,0.0,1.0
	);

	float offs=0.0,i=0.0;
	for(int j=0;j<128;j++)
	{
		float res=distfunc(ray_orig+ray_dir*offs);
		offs+=res;
		i=float(j);

		if(abs(res)<0.001) break;
		else if(offs>100.0) break;
	}

	float c=i/128.0;
	gl_FragColor=colour(c);
}
