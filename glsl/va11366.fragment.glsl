#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 position = gl_FragCoord.xy / resolution.xy;

	vec2 anchor = vec2( 0.5, 0.5 );
	vec2 corner = vec2( 0.6, 0.6 );
	vec2 feather = vec2( 10.0, 10.0 );
	float border = 50.0;

	
	vec2 pixelSize = vec2( 1.0 ) / resolution.xy;
	
	feather = feather * pixelSize;
	border  = border / 2.0;

	vec2 borderWH  = vec2( border * pixelSize );
	vec2 borderWHFull = borderWH - feather;
	
	vec2 wh = abs( anchor - corner );
	vec2 d  = mod( abs ( position - anchor ), wh );
	
	if ( d.x >= ( wh.x - borderWH.x ) )
	{
		d.x = wh.x - d.x;
	}
	
	if ( d.y >= ( wh.y - borderWH.y ) )
	{
		d.y = wh.y - d.y;
	}
	
	gl_FragColor = vec4( 1.0, 1.0, 1.0, 0.0 );

	if ( d.x <= borderWH.x )
	{
		if ( d.x < borderWHFull.x )
		{
			gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
		}
		else
		{
			gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 - ( d.x - borderWHFull.x ) / ( borderWH.x - borderWHFull.x ) );
		}
	}
	
	if ( d.y <= borderWH.y )
	{
		if ( d.y < borderWHFull.y )
		{
			gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
		}
		else
		{
			gl_FragColor = vec4( 1.0, 1.0, 1.0, clamp( gl_FragColor.a + (  1.0 - ( d.y - borderWHFull.y ) / ( borderWH.y - borderWHFull.y ) ), 0.0, 1.0 ) );
			
		}
	}

	gl_FragColor.rgb *= pow( gl_FragColor.a, 1.0 );

}