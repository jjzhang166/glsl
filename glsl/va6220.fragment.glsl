#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distf(vec3 p)
{
	float d1 = dot(p, vec3(0.0, 1.0, 0.0));
	float f = pow(abs(sin(time * 2.0)), 0.75);
	vec2 q = vec2(length(p.xz)-2.0 - f * 0.5,p.y - f - 0.5);
        float d2 =  length(q)-0.5;
	return min(d1, d2);
}

void main( void ) {

	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    	vec3 camPos = vec3(0.0, 3.0, 5.0);
    	vec3 camTarget = vec3(0.0, 0.0, -1.0);

    	vec3 camDir = normalize(camTarget-camPos);
    	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    	vec3 camSide = cross(camDir, camUp);
   	float focus = 1.0;

    	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
   	vec3 ray = camPos;
	const float MAX_ITER = 60.0;
	
	float dist = 0.0;
	float totalDist = 0.0;
	
	const float MAX_DIST = 200.0;
	//gl_FragColor = vec4(vec3(0.0, 0.5, 1.0) * pos.y, 1.0);
	
	float steps = 0.0;
	
	for(float i = 0.0; i < MAX_ITER; i++)
	{
		dist = distf(ray + rayDir * totalDist);
		
		if(dist < 0.001)
		{
			break;	
		}
		
		steps++;
		totalDist += dist;
	}
	if(dist < 0.001)
	{
		gl_FragColor = vec4(vec3(1.0 - (steps / MAX_ITER)), 1.0);
	}
	
	
	
}