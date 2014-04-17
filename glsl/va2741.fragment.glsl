#ifdef GL_ES
precision mediump float;
#endif

// Fixed return path problem!

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 Flag1( vec2 p )
{
	vec3 vResult = vec3(1.0, 0.48, 0.15);
	if((p.y > 0.6 && p.y < 0.7) || (p.x > 0.7 && p.x < 0.76))  vResult = vec3(1.0, 0.9, 0.3);
	return vResult;
}

vec3 Flag2( vec2 p )
{
	vec3 vResult = vec3(1, 1, 1);
	if (-p.x + 1.0 > p.y) vResult = vec3(0, 0, 1);
	if (p.y < 0.5) {
		vResult = vec3(1, 0, 0);
		if (p.x < p.y) vResult = vec3(0, 0, 1);
	}		
	
	return vResult;
}

vec3 Flag3( vec2 p )
{
	vec3 c = vec3(0.0);
	if(p.y < 0.333)
		c = vec3(0.0, 0.9, 0.0);
	else if(p.y > 0.333 && p.y < 0.666) 
		c = vec3(1.0, 1.0, 1.0);
	else
		c = vec3(1. ,0,0);
	return c;
}

vec3 Flag4( vec2 p )
{
	float gb = 1.0;
	if (p.y < 0.5)
		gb = 0.0;

	return vec3( 1.0, gb, gb);
}

vec3 Flag5( vec2 p )
{
	p = p - vec2(0.5, 0.5);
	p.y *= resolution.y / resolution.x;
	vec3 vResult = vec3(1, 1, 1);
	
	if (length(p) < 0.15) {
		vResult = vec3(8, 0, 0);
	}	
	return vResult;
}

vec3 Flag6( vec2 p )
{
	vec3 kRed = vec3( 204.0 / 255.0, 0.0, 0.0 );
	vec3 kWhite = vec3( 1.0, 1.0, 1.0 );
	vec3 kBlue = vec3( 0.0, 0.0, 102.0 / 255.0 );
	
	vec3 vResult = kBlue;

	p = p * 2.0 - 1.0;
	float d = -p.x * sign(p.y) + p.y * sign(p.x);
	
	if((abs(p.x) < (6.0/60.0)) || (abs(p.y) < (6.0/30.0)))
	{
		vResult = kRed;
	}
	else 
	if((abs(p.x) < (10.0/60.0)) || (abs(p.y) < (10.0/30.0)))
	{
		vResult = kWhite;
	}
	else 
	if( (d > 0.0)  && (d < 0.15))
	{
		vResult = kRed;
	}
	else
	if( (d > -0.15 * 3.0 / 2.0)  && (d < 0.15 * 3.0 /2.0))
	{
		vResult = kWhite;
	}
	
	return vResult;
}

vec3 GetFlagCol(vec2 p, float index)
{
	float fFlagCount = 6.0;
	index = mod(index, fFlagCount);
	if(index < 0.5)
	{
		return Flag1(p);
	}
	else
	if(index < 1.5)
	{
		return Flag2(p);
	}
	else
	if(index < 2.5)
	{
		return Flag3(p);
	}
	else
	if(index < 3.5)
	{
		return Flag4(p);
	}
	else
	if(index < 4.5)
	{
		return Flag5(p);
	}
	else
	if(index < 5.5)
	{
		return Flag6(p);
	}
return 	vec3(0.0);
}

void main( void ) 
{
	vec2 p = gl_FragCoord.xy / resolution.xy;
	
	
	vec2 p2 = p * 10.0;
	
	p2.y += time;
	
	float index = floor(p2.x) + floor(p2.y);
	vec2 vFlagCoord = fract(p2) * 1.25;
	
	vec3 vCol = vec3(0.0);
	if((vFlagCoord.x <= 1.0) && (vFlagCoord.y <= 1.0))
	{
		vCol = GetFlagCol( vFlagCoord, index );
	}
	
	gl_FragColor = vec4( vCol, 1.0 );
}
