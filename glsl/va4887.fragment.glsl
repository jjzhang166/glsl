#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec2 p) {
	p=(p);
	return fract(sin(p.x*45.11+p.y*97.23)*878.73+733.17)*2.0-1.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color = vec3(0.0);
	
	float closestDist = 999.0;
	
	for(int i = 0; i < 50; i ++)
	{
		vec2 dotPos = vec2((noise(vec2(float(i) + 0.1, float(i))) + 1.0) * 0.5, (noise(vec2(float(i) + 0.05, float(i) - 0.2))+ 1.0) * 0.5);
		
		
		float dist = distance(dotPos, position);
		if(closestDist > dist)
		{
			closestDist = dist;	
			color = vec3(noise(vec2(float(i + 1), float(i + 2))), noise(vec2(float(i + 3), float(i + 4))), noise(vec2(float(i + 5), float(i + 6))));
		}
	}
	
	gl_FragColor = vec4( color, 1.0 );

}