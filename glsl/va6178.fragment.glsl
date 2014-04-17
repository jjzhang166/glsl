#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdSphere( vec3 p, float s )
{
  	return length(p)-s;
}

float distf(vec3 p)
{
	return sdSphere(p,1.0);	
}



void main( void ) {

	vec2 pos = ( gl_FragCoord.xy*2.0 - resolution.xy ) / resolution.y;
	vec3 camPos = vec3(0.0,3.0,5.0);
	vec3 camTarget = vec3(0.0,0.0,-1.0);
	vec3 camDir = normalize(camTarget-camPos);
    	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    	vec3 camSide = cross(camDir, camUp);
	float focus = 1.0;
	
	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
   	vec3 ray = camPos;
	
	float dist = 0.0;
	float totalDist = 0.0;
	
	const float MAX_ITER = 150.0;
	const float MAX_DIST = 200.0;
	
	for(float i = 0.0; i < MAX_ITER; i++)
	{
		dist = distf(ray + rayDir * totalDist);
		
		if(dist < 0.001)
		{
			break;	
		}
		
		totalDist += dist;
	}
	if(dist < 0.001)
	{
		gl_FragColor = vec4(vec3(1.0 / totalDist * 2.0), 1.0);
	}
	else
	{
		gl_FragColor = vec4(vec3(0.0, 0.5 * pos.y, 1.0), 1.0);	
	}	
}