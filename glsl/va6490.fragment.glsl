/*
awful code is awful
*/

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float MAX_TRAIL = 2.0;
const float TRAIL_INC = .050;
/*
0
.
4...2
.   . 
1   3
*/

// ptB can be whatever!
bool areCollinear( vec2 ptA, vec2 ptB, vec2 ptC )
{
	// here, have a proper areCollinear
	// actually I'm not sure what this script was supposed to do but this function actually checks if points are collinear
	// so there's probably something wrong with the script
	return abs( ( ptB.x - ptA.x ) * ( ptC.y - ptA.y ) - ( ptC.x - ptA.x ) * ( ptB.y - ptA.y ) ) < .110;
}

void main( void ) {
	if( TRAIL_INC <= 0.001 )
		return;
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) + vec2( -1.0 * mouse.x, -1.0 * mouse.y  );
	pos *= vec2( 50.0, 50.0 );
	float timeDiff = 1.0;
	float charHeight = 10.0;
	float charWidth = 3.;
	vec3 color = vec3( 0.0 );
	vec2 pt0, pt1, pt2, pt3, pt4;
	float t;
	bool isOnBG = true;
	for( float timeDiff = 0.0; timeDiff <= MAX_TRAIL; timeDiff += TRAIL_INC )
	{
		t = time - timeDiff;
		pt0.x = 16.0 * pow( sin( t ), 3.0 ); //sin( time - timeDiff ) * cos( time - timeDiff ) * log( time - timeDiff );
		pt0.y = 3.0 * cos( t ) - 5.0 * cos( 2.0 * t ) - 2.0 * cos( 3.0 * t ) - cos( 4.0 * t ); //pow( abs( time - timeDiff ), .3 ) * sqrt( cos( time - timeDiff ) ); 
		pt0 *= 5.0;
		pt1 = pt0 + vec2( 0.0, -1.0 * charHeight); 
		pt2 = pt0 + vec2( charWidth, -0.5 * charHeight );
		pt3 = pt0 + vec2( charWidth, -1.0 * charHeight );
		pt4 = pt0 + vec2( 0.0, -0.5 * charHeight );
		if( areCollinear( pt0, pos, pt1 ) || areCollinear( pt4, pos, pt2 ) || areCollinear( pt2, pos, pt3 ) )
		{
			color.g = .5 * sin( timeDiff ) + .5;
		}
			
	}
	for( float timeDiff = 0.0; timeDiff <= MAX_TRAIL; timeDiff += TRAIL_INC)
	{
		t = time - timeDiff;
		pt0.x = 16.0 * pow( 2.0 * cos( t ), 3.0 ); //sin( time - timeDiff ) * cos( time - timeDiff ) * log( time - timeDiff );
		pt0.y = 3.0 * cos( t ) - 5.0 * sin( 2.0 * t ) - 2.0 * cos( 3.0 * t ) - cos( 4.0 * t ); //pow( abs( time - timeDiff ), .3 ) * sqrt( cos( time - timeDiff ) ); 
		pt0 *= 5.0;
		pt1 = pt0 + vec2( 0.0, -1.0 * charHeight); 
		pt2 = pt0 + vec2( charWidth, -0.5 * charHeight );
		pt3 = pt0 + vec2( charWidth, -1.0 * charHeight );
		pt4 = pt0 + vec2( 0.0, -0.5 * charHeight );
		if( areCollinear( pt0, pos, pt1 ) || areCollinear( pt4, pos, pt2 ) || areCollinear( pt2, pos, pt3 ) )
		{
			color.b = .5 * cos( timeDiff ) + .5;
		}
			
	}
		for( float timeDiff = 0.0; timeDiff <= MAX_TRAIL; timeDiff += TRAIL_INC )
	{
		t = time - timeDiff;
		pt0.x = 16.0 * pow( sin( t ), 3.0 ); //sin( time - timeDiff ) * cos( time - timeDiff ) * log( time - timeDiff );
		pt0.y = 3.0 * sin( t ) - 5.0 * sin( 2.0 * t ) - 2.0 * sin( 3.0 * t ) -sin( 4.0 * t ); //pow( abs( time - timeDiff ), .3 ) * sqrt( cos( time - timeDiff ) ); 
		pt0 *= 5.0;
		pt1 = pt0 + vec2( 0.0, -1.0 * charHeight); 
		pt2 = pt0 + vec2( charWidth, -0.5 * charHeight );
		pt3 = pt0 + vec2( charWidth, -1.0 * charHeight );
		pt4 = pt0 + vec2( 0.0, -0.5 * charHeight );
		if( areCollinear( pt0, pos, pt1 ) || areCollinear( pt4, pos, pt2 ) || areCollinear( pt2, pos, pt3 ) )
		{
			color.r = .5 * sin( timeDiff ) + .5;
		}
			
	}
	
	gl_FragColor = vec4( color, 1.0 );

}