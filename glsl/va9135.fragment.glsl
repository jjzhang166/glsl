#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec4 colour(float c)
{
	c*=12.0;
	vec3 res = vec3(0.0,0.0,0.0);
	res += smoothstep(1.0,2.0,c) * vec3(0.0,3.0,31.0)/255.0;
	res += smoothstep(2.0,3.0,c) * vec3(0.0,0.0,22.0)/255.0;
	res += smoothstep(3.0,4.0,c) * vec3(0.0,-1.0,25.0)/255.0;
	res += smoothstep(4.0,5.0,c) * vec3(0.0,0.0,32.0)/255.0;
	res += smoothstep(5.0,6.0,c) * vec3(0.0,1.0,23.0)/255.0;
	res += smoothstep(6.0,7.0,c) * vec3(0.0,0.0,-30.0)/255.0;
	res += smoothstep(7.0,8.0,c) * vec3(0.0,0.0,-57.0)/255.0;
	res += smoothstep(8.0,9.0,c) * vec3(0.0,70.0,-15.0)/255.0;
	res += smoothstep(9.0,10.0,c) * vec3(0.0,100.0,50.0)/255.0;
	res += smoothstep(10.0,11.0,c) * vec3(0.0,71.0,58.0)/255.0;
	res += smoothstep(11.0,12.0,c) * vec3(0.0,10.0,64.0)/255.0;
	res += smoothstep(12.0,13.0,c) * vec3(0.0,1.0,33.0)/255.0;
	return vec4(res,1.0);
}
float periodic(float x,float period,float dutycycle)
{
	x/=period;
	x=abs(x-floor(x)-0.5)-dutycycle*0.5;
	return x*period;
}

float pcount(float x,float period)
{
	return floor(x/period);
}

float distfunc(vec3 pos)
{
	vec3 gridpos=pos-floor(pos)-0.5;
	float r=length(pos.xy);
	float a=atan(pos.y,pos.x);
	a+=time*0.3*sin(pcount(r,3.0)+1.0)*sin(pcount(pos.z,1.0)*13.73);
	return min(max(max(
		periodic(r,3.0,0.2),
		periodic(pos.z,1.0,0.7+0.3*cos(time/3.0))),
		periodic(a*r,3.141592*2.0/6.0*r,0.7+0.3*cos(time/3.0))),0.25);
}

vec3 flare(vec2 spos, vec2 fpos, vec3 clr)
{
	vec3 color;
	float d = distance(spos, fpos);
	vec2 dd;
	dd.x = spos.x - fpos.x;
	dd.y = spos.y - fpos.y;
	dd = abs(dd);
	
	color = clr * max(0.0, 0.025 / dd.y) * max(0.0, 1.1 -  dd.x);
	color += clr * max(0.0, 0.05 / d);
	color += clr * max(0.0, 0.1 / distance(spos, -fpos)) * 0.15 ;
	color += clr * max(0.0, 0.13 - distance(spos, -fpos * 1.5)) * 1.5 ;
	color += clr * max(0.0, 0.07 - distance(spos, -fpos * 0.4)) * 2.0 ;
	
	
	return color;
}

float noise(vec2 pos)
{
	return fract(1111. * sin(111. * dot(pos, vec2(2222., 22.))));	
}

vec4 flareColor() 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	position.x *= resolution.x / resolution.y;
	vec3 color = flare(position, vec2(-cos(time * 1.0), 0.0) * 0.4, vec3(0.5, 1.0, 1.5) * (sin(time * 10.0) * 0.5 + 0.8));
	return vec4( color * (0.95 + noise(position*0.001 + 0.00001) * 0.05), 1.0 );
}

void main()
{
	float mx = 0.5;
	float my = 0.5;
	
	vec2 coords=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);

	vec3 ray_dir=normalize(vec3(coords,1.0+0.0*sqrt(coords.x*coords.x+coords.y*coords.y)));
	vec3 ray_pos=vec3(32.0*pow(0.5-mx, 1.),32.0*(0.5-my),time*10.0);
	float a=cos(time)*0.5*0.4;
	ray_dir=ray_dir*mat3(
		cos(a),0.0,sin(a),
		0.0,1.0,0.0,
		-sin(a),0.0,cos(a)
	);

	float i=192.0;
	for(int j=0;j<192;j++)
	{
		float dist=distfunc(ray_pos);
		ray_pos+=dist*ray_dir;

		if(abs(dist)<0.001) { i=float(j); break; }
	}

	float c=i/192.0;
	gl_FragColor=colour(c)+flareColor();
}
