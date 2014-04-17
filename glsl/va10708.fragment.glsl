#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct VT
{
	vec3 v;
	vec3 c;
};
	
struct RECT
{
	float left;
	float right;
	float top;
	float bottom;
};

mat3 getMatrixRotationAxis(const vec3 v, float a)
{
	return mat3(v.x * v.x * (1.0 - cos(a)) + cos(a), v.x * v.y * (1.0 - cos(a)) - v.z * sin(a), v.z * v.x * (1.0 - cos(a)) + v.y * sin(a),
		    v.x * v.y * (1.0 - cos(a)) + v.z * sin(a), v.y * v.y * (1.0 - cos(a)) + cos(a), v.y * v.z * (1.0 - cos(a)) - v.x * sin(a),
		    v.z * v.x * (1.0 - cos(a)) - v.y * sin(a), v.y * v.z * (1.0 - cos(a)) + v.x * sin(a), v.z * v.z * (1.0 - cos(a)) + cos(a));
}

RECT calcRect(float fov, float Distance)
{
	RECT rect;
	rect.top = tan(fov * 0.5) * Distance;
	rect.bottom = -tan(fov * 0.5) * Distance;
	rect.left = -tan(fov * 0.5) * Distance;
	rect.right = tan(fov * 0.5) * Distance;
	
	return rect;
}

vec3 getRayPos(RECT rect, vec2 pos, float Distance)
{
	return vec3(rect.left + (rect.right - rect.left) * pos.x,
		rect.bottom + (rect.top - rect.bottom) * pos.y,
		   Distance);
}

float getPower(vec3 v)
{
	return sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
}

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );


	//Create Vertex
	VT Vt[3];
	Vt[0].v = vec3(-8.0, -2.0, 1.0);
	Vt[1].v = vec3(4.0, 14.0, 4.0);
	Vt[2].v = vec3(4.0, -2.0, 1.0);
	Vt[0].c = vec3(1.0, 0.0, 0.0);
	Vt[1].c = vec3(0.0, 1.0, 0.0);
	Vt[2].c = vec3(0.0, 0.0, 1.0);
	const vec3 VtPos = vec3(0.0, -5.0, 16.0);
	
	mat3 mtrxRotationAxis = getMatrixRotationAxis(vec3(0.0, 1.0, 0.0), time * 0.5);
	for (int i = 0; i < 3; i++)
	{
		//Vt[i].v = mtrxRotationAxis * Vt[i].v;
		Vt[i].v += VtPos;
	}
	float fov = 1.0;
	float Near = 10.0;
	float Far = 40.0;
	RECT rcNear, rcFar;
	rcNear = calcRect(fov, Near);
	rcFar = calcRect(fov, Far);

	
	//Calc Ray Pos
	vec3 RayBegin = getRayPos(rcNear, pos, Near);
	vec3 RayEnd = getRayPos(rcFar, pos, Far);
	
	
	//Ray Traceing
	vec3 Color = vec3(0.0, 0.0, 0.0);

	vec3 Normal = normalize(cross(Vt[1].v - Vt[0].v, Vt[2].v - Vt[0].v));
	float Dot1 = dot(Normal, RayBegin - Vt[0].v);
	float Dot2 = dot(Normal, RayEnd - Vt[0].v);
	
	if ((Dot1 < 0.0 && Dot2 > 0.0) || (Dot1 > 0.0 && Dot2 < 0.0))
	{
		float H1 = getPower(cross(normalize(Vt[1].v - Vt[0].v), RayBegin - Vt[0].v));
		float H2 = getPower(cross(normalize(Vt[1].v - Vt[0].v), RayEnd - Vt[0].v));

		vec3 CrossPos = RayBegin + (RayEnd - RayBegin) * (abs(H1) / (abs(H1) + abs(H2)));
	
		bool Draw = true;
		for (int i = 0; i < 3; i++)
		{
			vec3 EdgeNormal; 
			if (i == 2)
				EdgeNormal = cross(Normal, Vt[0].v - Vt[i].v);
			else
				EdgeNormal = cross(Normal, Vt[i + 1].v - Vt[i].v);

			EdgeNormal = normalize(EdgeNormal);
	
			float Dot = dot(CrossPos - Vt[i].v, EdgeNormal);
			if (Dot < 0.0)
			{
				Draw = false;
				break;
			}
		}
		if (Draw)
		{
			float d[3];
			float dTotal = 0.0;
			for (int i = 0; i < 3; i++)
			{
				d[i] = distance(CrossPos, Vt[i].v);
				dTotal += d[i];
			}
			
			Color = Vt[0].c * (d[0] / dTotal) + Vt[1].c * (d[1] / dTotal) + Vt[2].c * (d[2] / dTotal);
		}
	}
	



	gl_FragColor = vec4(Color, 1.0 );

}