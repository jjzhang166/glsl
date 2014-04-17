#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 1.1 * n_xy;
}

float PointDistance( vec2 a, vec2 b )
{
	float dX = b.x-a.x;
	float dY = b.y-a.y;
	return sqrt(dX*dX + dY*dY);
}

void Sun( float distSun, float sunSize, float distSunEdgeMod, vec4 sunColour, vec4 back, vec2 sunPos)
{
	if( distSun <= sunSize )
	{	
		vec2 position2 = sunPos * resolution.xy;
		float intensity = cnoise((gl_FragCoord.xy - position2) /22.0 - vec2(0.0, 1.0 * time)) - distance(position2, gl_FragCoord.xy) / 26.0;
		float r = intensity + 3.5;
		float g = intensity + 3.0;
		float b = intensity + 2.5;
		
		if( r <= 0.0 )
		{
			gl_FragColor = back;
		}
		else
		{
			gl_FragColor = vec4(r, g, b, 1.0);
		}
	}
		
}

// Just screwing around.
void main( void ) 
{
	vec2 sunPos = vec2( 0.5, 0.5 );
	vec2 sunSizes = vec2( 1280.0, 00.0 );
	vec4 sunColour = vec4( 0.9, 0.9, 0.0, 1.0 );
	float sunTotalSize = sunSizes.x + sunSizes.y;
	
	vec2 planetPos = vec2( 0.5, 0.5 );
	vec2 planetSizes = vec2( 25.0, 14.0 );
	vec4 planetColour = vec4( 0.0, 0.0, 1.0, 1.0 );
	float planetTotalSize = planetSizes.x + planetSizes.y;
	
	float time2 = sin(time)-0.9;
	float pathDist = sin(time);
	vec2 pathPos = vec2( sin(pathDist), cos(pathDist) );
	
	planetPos.x = planetPos.x + (pathPos.x * 0.3);
	
	
	float distSun    = PointDistance( gl_FragCoord.xy, sunPos.xy * resolution.xy );
	float distPlanet = PointDistance( gl_FragCoord.xy, planetPos.xy * resolution.xy );

	
	float distSunEdge    = abs( distSun - sunTotalSize  );
	float distSunEdgeMod = clamp( (distSunEdge / sunTotalSize), 0.0, 1.0 );
	
	float distPlanetEdge    = abs( distPlanet - planetTotalSize  );
	float distPlanetEdgeMod = clamp( (distPlanetEdge / planetTotalSize), 0.0, 1.0 );
	
	vec4 basebackColour = vec4( 0.04 * sin(time), 0.29 * sin(time), 0.43*sin(time), 1.0 );
	
	
	
	vec4 currentBackColour = vec4( basebackColour.r, basebackColour.g, basebackColour.b, 1.0 );
	
	vec4 finalCol = vec4( 0.0,0.0,0.0,1.0 );
	
	// If either circles...
	if( distSun <= sunTotalSize || distPlanet <= planetTotalSize )
	{
		// This is wrong...
		if( time2 > 0.0 ) 
		{
			if( distPlanet <= planetTotalSize )
			{
				if( distPlanet <= planetTotalSize )
				{
					gl_FragColor = vec4( planetColour.r *sin(time), planetColour.g ,planetColour.b ,1.0);
				}
				else
				{
					//vec4 haloColour = currentBackColour;
					//float haloMod   = (1.0 * distPlanetEdgeMod) ;
					//gl_FragColor = vec4( clamp(haloColour.r+haloMod,0.0,1.0), clamp(haloColour.g+haloMod,0.0,1.0), clamp(haloColour.b+haloMod,0.0,1.0), 1.0 );
				}	
			}	
			
			// Sun...
			if( distSun <= sunTotalSize )
			{
				Sun( distSun, sunTotalSize, distSunEdgeMod, sunColour, currentBackColour, sunPos);	
			}
		}
		// Going left.
		else
		{
			
			// Sun...
			if( distSun <= sunTotalSize )
			{
				Sun( distSun, sunTotalSize, distSunEdgeMod, sunColour, currentBackColour, sunPos );	
			}
			
			if( distPlanet <= planetTotalSize )
			{
				if( distPlanet <= planetTotalSize )
				{
					gl_FragColor = vec4( planetColour.r *sin(time), planetColour.g ,planetColour.b ,1.0);
				}
				else
				{
					//vec4 haloColour = currentBackColour;
					//float haloMod   = (1.0 * distPlanetEdgeMod) ;
					//gl_FragColor = vec4( clamp(haloColour.r+haloMod,0.0,1.0), clamp(haloColour.g+haloMod,0.0,1.0), clamp(haloColour.b+haloMod,0.0,1.0), 1.0 );
				}	
			}
			
			
			
		}
		
		
		
	}
	// Background.
	else
	{
		gl_FragColor = currentBackColour;
	}

}