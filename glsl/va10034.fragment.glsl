#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float opUnion( float d1, float d2 )
{
    return min(d1,d2);
}

float box( vec3 p, vec3 b , vec3 boxPos)
{
	return length(max(abs(p - boxPos)-b,0.0));
}

float structure(vec3 p, vec3 camPos)
{
	float s = box(p, vec3(0.1, 0.9, 0.1), vec3(-1.5, 0.7, 0.0));
	float start = float((int(camPos.z / 3.0)));
	
	for (float i = 0.0; i < 5.0; i++)
	{
		vec3 structPos = vec3(0.0, 0.0, 3.0*(i+start));
		s = opUnion(s, box(p, vec3(0.1, 0.9, 0.1), vec3(1.5, 0.7, 0.0)+structPos));
		s = opUnion(s, box(p, vec3(1.5, 0.1, 0.1), vec3(0.0, 1.5, 0.0)+structPos));	
		s = opUnion(s, box(p, vec3(0.1, 0.9, 0.1), vec3(-1.5, 0.7, 0.0)+structPos));
	}

	
	return s;
}

float ground(vec3 p, vec3 cPos)
{
	float s = box(p, vec3(4, 0.01, 1e20), vec3(0.0, -1.1,cPos.z));
	return s;
}

//track starts at origin
//space the track pieces evenly apart
float track( vec3 p, vec3 camPos )
{
	float s = opUnion(box(p, vec3(0.01, 0.1,1e20), vec3(-0.3, 0.01, 0.0)),
				   box(p, vec3(0.01, 0.1,1e20), vec3(0.3, 0.01, 0.0)));
	
	float start = float((int(camPos.z/ 0.2)));
	
	for (float i = 0.0; i < 20.0; i++)
	{
		s = opUnion(s, box(p, vec3(0.5, 0.01, 0.03), vec3(0.0, 0.0, 0.0+(0.2 * (i+start)))));
	}

	return s;
}

float walls(vec3 p, vec3 camPos)
{
	float s = box(p, vec3(0.0, 0.0, 0.0), vec3(-0.5, 0.1, 3.0));

	for (float i = 1.0; i < 12.0; i++)
	{
		s = opUnion(s, box(p, vec3(0.1, 0.05, 1e20), vec3(-1.6, -0.3+0.17*i, 1.0)));
		s = opUnion(s, box(p, vec3(0.1, 0.05, 1e20), vec3(1.6, -0.3+0.17*i, 1.0)));
	}
	return s;
}

void main(void)
{
	vec2 uv = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;
	
	const vec3 CAM_UP = vec3(0.0, 1.0, 0.0);
	vec3 CAM_POS = vec3(0.0, 0.5,time);
	vec3 CAM_LOOKPOINT = vec3(0.0, 0.5, CAM_POS.z+5.0);
	
	vec3 lookDirection = normalize(CAM_LOOKPOINT - CAM_POS);
	vec3 viewPlaneU = normalize(cross(CAM_UP, lookDirection));
	vec3 viewPlaneV = cross(lookDirection, viewPlaneU);
	vec3 viewCenter = lookDirection + CAM_POS;
	
	vec3 fragWorldPos = viewCenter + (uv.x * viewPlaneU * resolution.x / resolution.y) + (uv.y * viewPlaneV);
	vec3 fragWorldToCamPos = normalize(fragWorldPos - CAM_POS);

	const float farClip = 10.0;
	
	//current point on the ray
	vec3 p;
	
	//distance to CAM_POS from p
	float f = 0.0;

	float s[4];
	s[0] = s[1] = s[2] = s[3] = 0.01;
	
	p = CAM_POS + fragWorldToCamPos*f;
	int hit = 0;
	
	for (int i = 0; i < 100; i++)
	{
		if (f > farClip)
		{
			break;
		}
		
		s[0] = track(p, CAM_POS);
		s[1] = structure(p, CAM_POS);
		s[2] = walls(p, CAM_POS);
		s[3] = ground(p, CAM_POS);
		
		int index = 0;

		float iVal = 1.0;
		for (int k = 0; k < 4; k++)
		{
			if (s[k] <= iVal)
			{
				iVal = s[k];
				index = k;
			}
		}
		
		
		
		float lightStrength = 0.2;
		float atten = 1.5*length(uv);
		if ( s[0] < 0.001 || s[1] < 0.001 || s[2] < 0.001 || s[3] < 0.001 )
		{
			if (index==3)
			{
				gl_FragColor = vec4(1.0, 0.6, 0.0, 1.0)*(1.0-s[0]/(farClip*(lightStrength+0.05)))*atten;
				return;
			}
			//track
			if (index==0)
			{
				gl_FragColor = vec4(0.9, 0.9, 0.9, 1.0)*vec4(length(uv)*1.5)*atten;
				return;
			}
			//struct
			if (index==1)
			{
				gl_FragColor = vec4(0.4, 0.2, 0.0, 1.0)*(1.0-s[0]/(farClip*lightStrength))*atten;
				return;
			}
			//walls
			if (index==2)
			{
				gl_FragColor = vec4(0.4, 0.2, 0.0, 1.0)*(1.0-s[0]/(farClip*lightStrength))*atten;
				return;
			}
			//ground
			
		}
		
		f+=iVal;
		p = CAM_POS + fragWorldToCamPos*f;
	}
	
	if (f < farClip)
	{
		if ( p.y < -1.0)
		{
			gl_FragColor = vec4(0.4, 0.2, 0.1, 1.0) *vec4(length(uv));
			return;
		}
		
		gl_FragColor = vec4(0.0);
		return;
	}
	else
	{
		gl_FragColor = vec4(0.0);
		return;
	}
}