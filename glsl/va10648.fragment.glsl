#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Most of these numerical constants should depend on resolution
const float X_SPEED_FACTOR = 100.0;
const float Y_SPEED_FACTOR = 0.02;
const bool FLASH_ALL = false;
const bool FLASH_TRAIL = false;
float RADIUS = resolution.y / 50.0;
const float RADIUS_STEP = 0.009;
const int NUM_PASSES = 60;
const float TIME_STEP = .020;


vec2 getCenterPosition( float t )
{
	float amplitude = resolution.y / 2.0;
	float yOffset = amplitude;
	float x = mod( X_SPEED_FACTOR * t, resolution.x );
	float y = amplitude * sin( Y_SPEED_FACTOR * x ) + yOffset;
	//float y = amplitude;
	return vec2( x, y );
//	return vec2( mod( time, resolution.x ), 0.0 );
}

vec3 calcFlash()
{
	return vec3( tan( time / cos( time ) ), sin( time / tan( time ) ), cos( time / sin( time ) ) );
}

vec3 stepTrail( vec2 center, float t, int pass )
{
	//RADIUS += RADIUS_STEP * float( pass );
	//vec2 center = getCenterPosition( t );
	float dist = abs( distance( gl_FragCoord.xy, center ) ); 
	vec3 color;
	
	if( dist < RADIUS )
	{
		float magnitude = float( pass ) / float( NUM_PASSES );
		if( FLASH_TRAIL )
		{
			color += magnitude * calcFlash();
		}
		else
		{
			color += vec3( magnitude );
		}
	}
	else
	{
		
		//color.r += vec3( .01 );
		//color.r += 1.0 / float( NUM_PASSES );
	}
//	color.r += mod( dist, float( NUM_PASSES ) );
	if( FLASH_ALL )
	{
		color += calcFlash();
	}	
	gl_FragColor = vec4( color, 1.0 );
	t += TIME_STEP;
	return color;
}
void main( void )
{
//	vec2 center = vec2( sin( time ), cos( time ) );
//	vec2 center = ( resolution.xy / 2.0 ) + (resolution.y / 2.0) * vec2( sin( time ), cos( time ) );
//	vec2 center = ( resolution.xy / 2.0 ) + (resolution.y / 2.0) * vec2( sin( time ), mod( float(time), resolution.x ));
//	vec2 center = ( resolution.xy / 2.0 ) + (resolution.y / 2.0) * vec2( sin( time ), time );

	
//	vec3 color = vec3( sin( dist + time ), cos( dist + time ), tan( dist + time ) );
//	vec3 color = vec3( sin( dist ), sin( dist ), sin( dist ) );

	vec3 color = vec3( 0.0 );
	float t = time;
	for( int i = 0; i < NUM_PASSES; i ++ )
	{
		RADIUS += RADIUS_STEP * float( i );
//		stepTrail( getCenterPosition( t ), t, i );

		vec2 center = getCenterPosition( t );
		float dist = abs( distance( gl_FragCoord.xy, center ) ); 

		if( dist < RADIUS )
		{
			float magnitude = float( i ) / float( NUM_PASSES );
			if( FLASH_TRAIL )
			{
				color += magnitude * calcFlash();
			}
			else
			{
				color += vec3( magnitude );
			}
		}
		else
		{
			
			//color.r += vec3( .01 );
			//color.r += 1.0 / float( NUM_PASSES );
		}
//		color.r += mod( dist, float( NUM_PASSES ) );
		if( FLASH_ALL )
		{
			color += calcFlash();
		}	
		gl_FragColor = vec4( color, 1.0 );
		t += TIME_STEP;

	}

}