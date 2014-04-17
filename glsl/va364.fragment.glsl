// by @mnstrmnch

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float barWidth = 0.05;
float PI = 3.14159265;

vec3 c0 = vec3( 255.0, 215.0, 0.0 ) / vec3( 255.0 );
vec3 c1 = vec3( 1.0, 01.0, 01.0 );

void main( void ) 
{
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position -= 0.03;
  	position *= 0.15 * pow(length(position), -2.0);
  	position += 0.5;

  vec2 p = -1.0 + 2.0 * position;
  
  
  barWidth = (sin(10.05*p.x+15.*time)+2.)*0.01+.05;

	vec3 color = vec3( .5*abs(p.y), 0.1, 0.1 );

	for( int i = 6; i >= 0; i-- )
	{
		float barY = sin( time * 1.324 + float( i ) * 1.0 + p.x ) * 0.533 + sin( time * .194 + p.x * 03.5 ) * 0.2;

		if( p.y > barY - barWidth * 01.5 && p.y < barY + barWidth * 0.5 )
		{
			float angle = ( ( p.y - ( barY - barWidth * 0.5 ) ) / barWidth );
			color = mix(  c0+sin(p.x), c1, float( i ) / 47.0 ) * vec3( sin( angle * PI )  );
		}
			
	}

	for( int i = 1; i >= 0; i-- )
	{
		float barX = sin( time * 1.1347 + float( i ) * 0.1 + p.y * 01.25 ) * 0.25 + sin( time * 1. + float( i ) * 0.1 ) * 0.25;

		if( p.y < ( float( i ) / 47.0 ) * 2.0 - 1.0  && p.x > barX - barWidth * 0.5 && p.x < barX + barWidth * 0.5 )
		{
			float angle = ( ( p.x - ( barX - barWidth * 0.5 ) ) / barWidth );
			color = mix( c0, c1, float( i ) / 47.0 ) * vec3( sin( angle * PI ) );
		}
	}


	gl_FragColor = vec4( color, 1.0 );

}