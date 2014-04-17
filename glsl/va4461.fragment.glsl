#ifdef GL_ES
precision highp float;
#endif

uniform vec3 unResolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D fft;

uniform vec2 mouse;
uniform vec2 resolution;

uniform vec4 unPar;
uniform vec4 unPos;
uniform vec4 unBeatBassFFT;

float iSphere(in vec3 ro, in vec3 rd, in vec4 sph)
{
	vec3 oc = ro - sph.xyz;
	//float r = 1.0;
	float b = 2.0 * dot(oc, rd);
	float c = dot(oc, oc) - sph.w*sph.w;
	float h = b*b - 4.0*c;
	
	if(h < 0.0) return -1.0;
	
	float t = (-b - sqrt(h)) / 2.0;
	return t;
}

vec3 nSphere(in vec3 pos, in vec4 sph)
{
	return normalize(pos - sph.xyz) / sph.w;
}

float iPlane(in vec3 ro, in vec3 rd)
{
	return -ro.y / rd.y;
}

vec3 nPlane(in vec3 pos)
{
	return vec3(0.0, 1.0, 0.0);
}

vec4 sph1 = vec4(0.0, 1.0, 0.0, 1.0);
float intersect(in vec3 ro, in vec3 rd, out float resT)
{
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere(ro, rd, sph1);
	float tpla = iPlane(ro, rd);
	
	if(tsph > 0.0)
	{
		id = 1.0;
		resT = tsph;
	}
	
	if(tpla > 0.0 && tpla < resT)
	{
		id = 2.0;
		resT = tpla;
	}
	
	return id;
}

void main(void)
{
	vec3 light = normalize(vec3(cos(time) * 5.0, sin(time) * 5.0, cos(time) + sin(time) * 5.0));
	vec2 uv = (gl_FragCoord.xy / resolution.xy);
	
	sph1.x = 0.5 * cos(time);
	sph1.z = 0.6 * sin(time);
	
	vec3 ro = vec3(0.0, 0.5, 3.0);
	vec3 rd = normalize(vec3((-1.0+2.0*uv)*vec2(1.78,1.0), -1.0));
	
	float t;
	float id = intersect(ro, rd, t);
	
	vec3 col = vec3(0.7);
	if(id > 0.5 && id < 1.5)
	{
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere(pos, sph1);
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3(0.9, 0.8, 0.6) * dif * ao + vec3(0.1, 0.2, 0.4) * ao;
	}
	else if(id > 1.5)
	{
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane(pos);
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float amb = smoothstep(0.0, sph1.w, length(pos.xz-sph1.xz));
		col = vec3(amb*0.7);
	}
	
	col = sqrt(col);

	gl_FragColor = vec4(col, 1.0 );
}