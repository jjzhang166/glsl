// by @mnstrmnch

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float barWidth;
float PI = 3.14159265;

vec3 c0 = vec3( 255.0, 255.0, 0.0 ) / vec3( 255.0 );
vec3 c1 = vec3( 1.0, 0.0, 1.0 );

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xx ) * 4.0 - vec2( 0.5, 2. );
	barWidth = (cos(p.x+4.*time))*0.05;

	vec3 color = vec3( 0. );

	for( int i = 25; i >= 0; i-- )
	{
		float barY = cos( float( i )  ) * sin( p.x );

		if( p.y > barY - barWidth * 1.9 && p.y < barY + barWidth * 0.5 )
		{
			float angle = ( ( p.y - ( barY - barWidth  ) ) / barWidth );
			color = mix(  c0*sin(p.x), c1, float( i )  ) * vec3( sin( angle * PI * 0.1  )  );
		}
			
	}

	gl_FragColor = vec4( color, 1.0 );

}