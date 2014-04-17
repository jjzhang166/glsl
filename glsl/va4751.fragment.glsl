#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//voronoi diagram
//~MrOMGWTF

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color = vec3(0.0);
	
	vec2 points[6];
	points[0] = vec2(0.25, 0.1);
	points[1] = vec2(0.10, 0.6);
	points[2] = vec2(0.73, 0.21);
	points[3] = vec2(0.32, 0.40);
	points[4] = mouse;
	points[5] = vec2(0.42, 0.90);
	
	vec3 colors[6];
	colors[0] = vec3(0.75, 0.15, 0.0);
	colors[1] = vec3(0.2, 0.6, 0.2);
	colors[2] = vec3(0.2, 0.5, 1.0);
	colors[3] = vec3(1.0, 0.5, 0.25);
	colors[4] = vec3(0.8, 0.5, 0.5);
	colors[5] = vec3(1.0, 0.5, 1.0);
	
	float closestDist = 999.0;
	int closestId = -1;
	
	for(int i = 0; i < 6; i++)
	{
		vec2 delta = points[i]- position;
		float dist = abs(delta.x)+abs(delta.y);
		if(closestDist > dist)
		{
			closestDist = dist;
			closestId = i;
		}
	}
	
	if(closestId == 0)
	{
		gl_FragColor = vec4(colors[0], 1.0);
	}
	if(closestId == 1)
	{
		gl_FragColor = vec4(colors[1], 1.0);
	}
	if(closestId == 2)
	{
		gl_FragColor = vec4(colors[2], 1.0);
	}
	if(closestId == 3)
	{
		gl_FragColor = vec4(colors[3], 1.0);
	}
	if(closestId == 4)
	{
		gl_FragColor = vec4(colors[4], 1.0);
	}
	if(closestId == 5)
	{
		gl_FragColor = vec4(colors[5], 1.0);
	}
}													