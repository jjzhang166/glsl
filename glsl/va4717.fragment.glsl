#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 rotate( vec2 );

vec2 coordTransform( vec2 );

void drawAxis( vec2 );
void drawCircle( vec2, float );

void main( void ) 
{

	vec2 pos = coordTransform( gl_FragCoord.xy ); //( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;

	if( length( pos ) <=  10.0 )
	{
		gl_FragColor = vec4( 0.0, 0.0, 1.0, 1.0 );
	}
	drawAxis( pos );
}

vec2 rotate( vec2 pt, float angle )
{
	float r = length( pt );
	float theta = atan( pt.y / pt.x );
	theta += angle;
	
	return vec2( r * cos( theta ), r * sin( theta ) );	
}

vec2 coordTransform( vec2 pt )
{
	// Centered
	return pt - resolution.xy / 2.0;
}

void drawAxis( vec2 pt )
{
	if( pt.x < 1.0 && pt.x > -1.0 )
	{
		gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
	}
	else if( pt.y < 1.0 && pt.y > -1.0 )
	{
		gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
	}
}

void drawCircle( vec2 center, float r )
{
//	if( 
}