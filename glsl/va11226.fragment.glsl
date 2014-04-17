#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphereDist(float radius ,vec3 p)
{
    return length(p) - radius;	
}



void main( void ) {
	
	vec2 fragPos = (gl_FragCoord.xy / resolution.xy) - vec2(0.5,0.5);
	fragPos *= 2.0;
	fragPos.x *= resolution.x / resolution.y;

	vec3 ray = normalize(vec3(fragPos.xy, -1.0));
	vec3 camPos = vec3(0.0, 0.0, 2.0);
	vec3 p = camPos;
	
	vec3 col = vec3(0.0,0.3,0.0);
	const float minDist = 0.005;
	const float dist = 0.2;
	int iter = 0;
	
	float d = 10000.0;
	for(int i = 0; i < 20; ++i)
	{
		if(d < 0.0)
		{
			col = vec3(1.0, 1.0, 1.0);
		//	break;
		}
		
		d = p.x; //sphereDist(1.0, p);
		p += ray*dist;
	}

	
	gl_FragColor = vec4( col, 1.0 );
}