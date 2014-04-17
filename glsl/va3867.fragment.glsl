//by Muhammad Daoud

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

float density = 0.5;
float LOG2 = 1.442695;

vec4 pl1 = vec4(0.0, 1.0, 0.0, 1.0);
vec4 pl2 = vec4(0.0, -1.0, 0.0, 1.0);
vec4 pl3 = vec4(1.0, 0.0, 0.0, 1.0);
vec4 pl4 = vec4(-1.0, 0.0, 0.0, 1.0);
vec4 sp1 = vec4(sin(2.0*time)/1.25, - pl1.w + 0.25, - 4.0*time, 0.25);

bool iSphere(in vec4 sp, in vec3 ro, in vec3 rd, in float tm, out float t)
{
	vec3 d = ro - sp.xyz;
	float b = dot(rd, d);
	float c = dot(d, d) - sp.w*sp.w;
	t = b*b - c;
	if (t > 0.0)
	{
		t = - b -sqrt(t);
		return (t  > 0.0) && (t < tm);
	}
	return false;
}

vec3 nSphere(in vec3 pos, in vec4 sp)
{
	return (pos-sp.xyz)/sp.w;
}

bool iPlane(in vec4 pl, in vec3 ro, in vec3 rd, in float tm, out float t)
{
	t = -(dot(pl.xyz,ro)+pl.w)/dot(pl.xyz,rd);
	return (t > 0.0) && (t < tm);
}

float intersect(in vec3 ro, in vec3 rd, out vec3 co , in vec3 lightpos)
{
	float tm = 10000.0;
	float t;
	
	co = vec3(0.0);
	
	if (iSphere(sp1, ro, rd, tm, t))
	{
		vec3 pos = ro + t*rd;
		vec3 nor = nSphere(pos, sp1);
		vec3 light = normalize(lightpos - pos);
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float ao = 0.5 + 0.5*nor.y; 
		co = vec3(0.6, 0.8, 0.9)*dif*ao + (0.1, 0.2, 0.3)*ao;
		tm = t;
	}
	if (iPlane(pl1, ro, rd, tm, t))
	{
		vec3 pos = ro + t*rd;
		vec3 light = normalize(lightpos - pos);
		co = vec3(abs(cos(pos.z)) * abs(sin(pos.z)));
		float rm = 10000.0;
		float r;
		if (iSphere(sp1, pos, light, rm, r))
		{
			float amb = smoothstep(0.0, 0.5, r);
			co = amb*co;
		}
		tm = t;
	}
	if (iPlane(pl2, ro, rd, tm, t))
	{
		vec3 pos = ro + t*rd;
		vec3 light = normalize(lightpos - pos);
		co = vec3(abs(cos(pos.z)) * abs(sin(pos.z)));
		float rm = 10000.0;
		float r;
		if (iSphere(sp1, pos, light, rm, r))
		{
			float amb = smoothstep(0.0, 0.5, r);
			co = amb*co;
		}
		tm = t;
	}
	if (iPlane(pl3, ro, rd, tm, t))
	{
		vec3 pos = ro + t*rd;
		vec3 light = normalize(lightpos - pos);
		co = vec3(abs(cos(pos.z)) * abs(sin(pos.z)));
		float rm = 10000.0;
		float r;
		if (iSphere(sp1, pos, light, rm, r))
		{
			float amb = smoothstep(0.0, 0.5, r);
			co = amb*co;
		}
		tm = t;
	}
	if (iPlane(pl4, ro, rd, tm, t))
	{
		vec3 pos = ro + t*rd;
		vec3 light = normalize(lightpos - pos);
		co = vec3(abs(cos(pos.z)) * abs(sin(pos.z)));
		float rm = 10000.0;
		float r;
		if (iSphere(sp1, pos, light, rm, r))
		{
			float amb = smoothstep(0.0, 0.5, r);
			co = amb*co;
		}
		tm = t;
	}
	
	return tm;
	
	co = sqrt(co);
}

void main( void ) {

	vec2 uv = 2.0*(gl_FragCoord.xy/resolution.xy) - 1.0;
	vec3 ro = vec3(0.0, 0.0, -4.0*time + 2.0);
	vec3 rd = normalize(vec3(uv*vec2(resolution.x/resolution.y,1.0), -1.0));
	vec3 co = vec3(0.0);
	
	vec3 lightpos = vec3(0.0, 0.0, sp1.z);

	float t = intersect(ro, rd, co, lightpos);
	
	vec3 pos = ro + t*rd;
	
	float ff = exp2(density*density*LOG2*(pos.z - ro.z));
	ff = clamp(ff, 0.0, 1.0);
	
	vec4 fc = vec4(0.66015625, 0.9140625, 0.9921875, 1.0);
	
	gl_FragColor = mix(fc, vec4(co, 1.0), ff);

}