#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 getCirclePos(float seed)
{
	return vec2(fract(abs(sin(time*0.5))+seed), abs(cos(time *0.3)));
}

bool circleHit(vec2 center, float radius, vec2 position)
{
	if (length(center-position) < radius)
		return true;
	else
		return false;
}

void main( void ) {
	
	vec2 position = gl_FragCoord.xy / resolution;
	
	vec2 circlePos = getCirclePos(3.);
	vec2 circlePos2 = getCirclePos(0.4255);
	
	if (circleHit(circlePos, 0.1, position))
	{
		gl_FragColor = vec4(1,1,1,1);
	}
	
	if (circleHit(circlePos2, 0.1, position))
	{
		gl_FragColor = vec4(1,0,0,1);
	}
		
}