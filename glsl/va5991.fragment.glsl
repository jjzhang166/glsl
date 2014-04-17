#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323846

void main( void ) {
	float minDist = 2.9;
	vec2 center = resolution / 2.0;
	
	for(int i = 0; i < 50; i++)
	{
		float Max = PI;
		float index = ((float(i) + 1.0) / 50.0) * Max;
		vec2 CurrentPosition = vec2(index,  pow(index, 2.0) * 15.0);

		vec2 offset = vec2(sin(CurrentPosition.x) * CurrentPosition.y, cos(CurrentPosition.x) * CurrentPosition.y);
		//offset = offset * 40.0;
		float fDist = distance(center + offset, gl_FragCoord.xy);
		
		if(fDist < minDist)
		{
			minDist = fDist;
		}
	}
	vec3 color = vec3((2.9 - minDist) / 2.9);
	gl_FragColor = vec4(color, 1.0);
}