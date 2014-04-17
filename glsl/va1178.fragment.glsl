#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float maxVec3(in vec3 p)
{
	return max(p.x, max(p.y, p.z));
}

float sphere0(in vec3 p)
{
	return distance(vec3(0.0, 0.0, 0.0), p) - 1.0;
}

float sphere1(in vec3 p)
{
	return distance(vec3(sin(time*3.0), cos(time), tan(time)), p) - 0.5;
}

float cube(in vec3 p)
{
	float l = 1.0;
	vec3 tp = abs(p) - l;
	//return min(maxVec3(tp), length(max(tp, 0.0)));
	return maxVec3(tp);
}

float plane(in vec3 p)
{
	return p.y + 5.0;
}

float s(in vec3 p)
{
	return sphere0(p)-0.5*cube(p);
	//return min(min(cube(p),sphere1(p)), plane(p));
}

vec3 n(in vec3 p)
{
	float e=0.1;
	vec3 n = vec3(s(p + vec3(e, 0, 0)) - s(p - vec3(e, 0, 0)), s(p + vec3(0, e, 0)) - s(p - vec3(0, e, 0)), s(p + vec3(0, 0, e)) - s(p - vec3(0, 0, e)));
	return normalize(n);
}

void main( void )
{
	float color = 0.2;
	float e = 0.0001;
	float t = time;

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	uv.x *= resolution.x/resolution.y;

	vec3 camPos = vec3(0.0, 0.0, 3.0);

	vec3 lightDir = vec3(sin(t*3.0)*2.0, cos(t), 1.0);
	lightDir = normalize(lightDir);


	vec3 camDir = vec3(uv.x-0.8889, uv.y-0.5, -0.5);
	camDir = normalize(camDir);
	
	vec3 rayNextPos, ray;
	int flag = 0;
	
	rayNextPos = ray = vec3(0.0, 0.0, 0.0);
	
	for(int i = 0; i < 100; i++)
	{
		if(flag == 1) break;
		
		rayNextPos = ray + camPos;
		ray += s(rayNextPos)*camDir + e;
		if(s(rayNextPos) < 0.001)
		{
			color = dot(n(rayNextPos), lightDir)*0.5 + 0.5;
		}
	}	
	
	gl_FragColor = vec4(color, color, color, 1.0);
}