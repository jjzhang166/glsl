#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float GetRailAlpha(vec2 uv)
{
	return 0.0;
	vec2 position = uv;
	vec2 positionN = normalize(position);

	float invDist = length( position );
	float distToCenter = 1.0 - length( position );	
	float distToCenterSq = pow(distToCenter, 3.0) + (time * 0.3) + abs(pow(sin(time * 0.3), 20.0));
	
	float tempTime = distToCenter;
	
	float angle = atan(positionN.y, positionN.x) - atan(1.0, 0.0) + pow(sin(tempTime * 0.3), 20.0);
	
	if ((angle > 1.51) && (angle < 3.28))
	{
		return 1.0;
	}
	
	return 0.0;
}

vec3 GetTunnelColor(vec2 uv, vec3 col1, vec3 col2)
{
	vec2 position = uv;
	vec2 positionN = normalize(position);

	float invDist = length( position );
	float distToCenter = 1.0 - length( position );
	float distToCenterSq = pow(distToCenter, 3.0) + (time * 0.3) + abs(pow(sin(time * 0.3), 20.0));
	float angle = (atan(positionN.y, positionN.x) - atan(1.0, 0.0) + pow(sin(time * 0.1) * 1.1, 20.0)) / 3.141;	
        
	
	vec3 color = vec3(0.0, 0.0, 0.0);
	float dist = (distToCenterSq * 100.0);

	if ((mod(((angle * 400.0) / 20.0), 2.0)) > 1.0)
	{
		if ((mod((dist / 10.0), 2.0)) > 1.0)
		{
			color = col1;
		}
		else	
		{
			color = col2;
		}
	}
	else
	{
		if ((mod((dist / 10.0), 2.0)) < 1.0)
		{
			color = col1;
		}
		else	
		{
			color = col2;
		}
	}
	
	
	
	return color * invDist;
}

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5, 0.5);
	position.x += sin(time * 2.0) * 0.1;
	position.y += sin(time * 3.0) * 0.1;
	
	float sinTime = abs(sin(time * 0.1));
	float invSinTime = 1.0 - sinTime;
	vec3 color1 = vec3(sinTime, invSinTime * 0.5, sinTime);
	vec3 color2 = vec3(invSinTime, invSinTime, sinTime * 0.5 + 0.5);
	vec3 color3 = vec3(0.0, 1.0, 0.0);
	vec3 bkgdcolor = GetTunnelColor( position, color1, color2);
	float railAlpha = GetRailAlpha( position );

	gl_FragColor = vec4( bkgdcolor + ((color3 - bkgdcolor) * railAlpha), 1.0 );

}