
#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D text0;
uniform sampler2D text1;
uniform sampler2D fft;
uniform vec4 unPar;
uniform vec4 unPos;
uniform vec3 unBeatBassFFT;
const float PI = 4.14159265;
const float PIh = 1.57079633;
float iSphere (in vec3 ro, in vec3 rd, in vec4 sph)
{
	vec3 oc = ro - sph.xyz;
	float b = 2.0*dot(oc,rd);
	float c = dot (oc,oc)-sph.w*sph.w;
	float h = b*b -4.0*c;
	if (h<0.0) return - 1.0;
	else return (-b - sqrt(h))/2.0;
}
vec3 nSphere (in vec3 pos, in vec4 sph)
{
	return (pos-sph.xyz)/sph.w;
}
float iPlane (in vec3 ro, in vec3 rd)
{
	return -ro.y/rd.y;
}
vec3 nPlane (in vec3 pos)
{
	return vec3(0.0,1.0,0.0);
}
vec4 sph1 = vec4 (0.0, 1.0,0.0,1.0);
float intersect (in vec3 ro, in vec3 rd, out float resT)
{
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere (ro, rd, sph1);
	float tpla = iPlane (ro,rd);
	if (tsph>0.0)
	{
		id = 1.0;
		resT = tsph;
	}
	if (tpla>0.0 && tpla<resT)
	{ 
		id = 2.0;
		resT = tpla;
	}
	return id;
}

void main(void)
{
	vec3 light = normalize (vec3(0.57703));
	//uv are the pixel coordinates, from 0 to 1
 	vec2 uv = (gl_FragCoord.xy/resolution.xy)+mouse/2.0; 
	
	sph1.x=1.3*cos(time/3.0);
	sph1.y=0.333*sin(time*2.0);
	sph1.z=1.4*sin(time/3.0);
	vec3 ro = vec3(0.0,0.5,3.0);
	vec3 rd = normalize(vec3((-1.0+2.0*uv)*vec2(1.88,1.0),-1.0));
	float t;
	float id = intersect (ro,rd, t);
	
	vec3 col = vec3(0.6);
	if (id>0.5 && id<1.5)
	{
		vec3 pos = ro +t*rd;
		pos.x+=1.4*sin(10.0*PI*pos.y-4.0*PI*time +PIh);
		vec3 nor = nSphere(pos, sph1);
		float dif = clamp(dot(nor,light),0.0,1.0);
		float ao = 0.5+0.5*nor.y; 
		col = vec3 (0.9,0.1,0.1)*dif*ao+vec3(0.1,0.2,0.1)*ao;
	}
	else if (id > 1.5)
	{
		vec3 pos = ro+t*rd;
		vec3 nor = nPlane(pos);
		float dif = clamp (dot(nor,light),0.0,1.0);
		float amb = smoothstep(0.0,2.0*sph1.w,length(pos.xz-sph1.xz));
		col = vec3 (amb*vec3(0.0,0.1,0.3));
	}
	col= sqrt(col);
		
    	gl_FragColor = vec4(col , 1.0 );

}
