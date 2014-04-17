#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Most of these numerical constants should depend on resolution (but they don't)
const float X_SPEED_FACTOR = 100.0;
const float Y_SPEED_FACTOR = 0.02;
const bool FLASH_ALL = false;
const bool FLASH_TRAIL = false;
float RADIUS = resolution.y / 50.0;
const float RADIUS_STEP = 0.01;
const int NUM_PASSES = 60;
const float TIME_STEP = .020;


vec2 getCenterPosition( float t )
{
	float amplitude = resolution.y / 2.0;
	float yOffset = amplitude;
	float x = mod( X_SPEED_FACTOR * t, resolution.x );
	float y = amplitude * sin( Y_SPEED_FACTOR * x ) + yOffset;
	return vec2( x, y );
}

vec3 calcFlash()
{
	return vec3( tan( time / cos( time ) ), sin( time / tan( time ) ), cos( time / sin( time ) ) );
}

void main( void )
{
	vec3 color = vec3( 0.0 );
	float t = time;
	for( int i = 0; i < NUM_PASSES; i ++ )
	{
		RADIUS += RADIUS_STEP * float( i );
		
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

		if( FLASH_ALL )
		{
			color += calcFlash();
		}	
		gl_FragColor = vec4( color, 1.0 );
		t += TIME_STEP;
	}
}