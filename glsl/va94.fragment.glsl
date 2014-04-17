// by @mnstrmnch

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat3 Rotation( float time )
{
	return  mat3( 1.0, 0.0, 0.0, 0.0, cos( time ), -sin( time ), 0.0, sin( time ), cos( time ) ) * 
	mat3( cos( time ), 0.0, sin( time ), 0.0, 1.0, 0.0, -sin( time ), 0.0, cos( time ) );
}
mat3 RotationX( float time )
{
	return  mat3( 1.0, 0.0, 0.0, 0.0, cos( time ), -sin( time ), 0.0, sin( time ), cos( time ) ); 
	//mat3( cos( time ), 0.0, sin( time ), 0.0, 1.0, 0.0, -sin( time ), 0.0, cos( time ) );
}
mat3 RotationY( float time )
{
	  //mat3( 1.0, 0.0, 0.0, 0.0, cos( time ), -sin( time ), 0.0, sin( time ), cos( time ) ); 
	return mat3( cos( time ), 0.0, sin( time ), 0.0, 1.0, 0.0, -sin( time ), 0.0, cos( time ) );
}

mat3 RotationZ( float time )
{
	  //mat3( 1.0, 0.0, 0.0, 0.0, cos( time ), -sin( time ), 0.0, sin( time ), cos( time ) ); 
	return mat3( cos( time ),  sin( time ), 0.0,  -sin( time ),  cos( time ),0.0,    0.0,0.0,1.0 );
}
mat3 ScaleX( float time )
{
	  //mat3( 1.0, 0.0, 0.0, 0.0, cos( time ), -sin( time ), 0.0, sin( time ), cos( time ) ); 
	return mat3( 1.0, 0.0, 0.0,  0.0,  1.0,0.0,    0.0,0.0,sin(time) );
}
vec3 BallColor( vec3 n )
{
	vec3 color = vec3( 132.0, 110.0, 255.0 ) / vec3( 255.0 );
	vec3 otherColor = vec3( 0.0, 201.0, 144.0 ) / vec3( 255.0 );
	//if( 1.0 - abs( n.x * 2.0 ) > abs( n.y * 0.0 ) ) color  = otherColor ;	
	//if( 1.0 - abs( n.y * 2.0 ) > abs( n.x * 10.0 ) ) color  = otherColor ;	
	//if( 1.0 - abs( n.z * 2.0 ) > abs( n.y * 10.0 ) ) color  = otherColor ;	
	//if( 1.0 - abs( n.y * 2.0 ) > abs( n.z * 10.0 ) ) color  = otherColor ;	
	//if( 1.0 - abs( n.x * 2.0 ) > abs( n.z * 10.0 ) ) color  = otherColor ;	
	//if( 1.0 - abs( n.z * 2.0 ) > abs( n.x * 10.0 ) ) color  = otherColor ;		
	
	if( abs(sin( n.x*n.y-n.z   ))<.52) color=otherColor;
	
	return color;
}

float FMod( float f )
{
	int i = int( f);
	return f - float( i );
}

void main( void ) 
{
	vec2 position = ( ( gl_FragCoord.xy - resolution.xy * 0.5 ) / resolution.xx ) * 7.0;
	vec3 color = vec3( 64.0, 94.0, 88.0 ) / vec3( 255.0 );

	//if( position.y < -0.5 ) color = vec3( 33.0, 42.0, 60.0 ) / vec3( 255.0 );

	
	for( int i = 0; i <1; i++ )
	{
		vec2 ballPosition;
		ballPosition.x = fract( time * 0.09 * float( i + 1 ) * 1.1224324 + pow( 1.0 + float( i ), 2.0 ) * 1.392752 ) * 9.0 - 4.5;
		ballPosition.y = abs( sin( time * 2.0 + float( i ) * 9.0 ) ) * 1.25 - 0.6;
		vec2 thisPosition = position - ballPosition;

		if( length( thisPosition ) < 2.0 &&  length( thisPosition )>1.0 ) 
		{
			float z = sqrt(( 1.0 - dot( thisPosition , thisPosition ))/1.0 );
			vec3 n = vec3( thisPosition , z );
			float shade = 0.25 + n.z * 0.75;
			normalize( n );
			color = BallColor( Rotation( time + float( i ) ) * n ) * shade;
			//color=BallColor(vec3(1.0,1.0,1.0))*shade;
		}
	}
	

       gl_FragColor = vec4( color, 1.0 );

}