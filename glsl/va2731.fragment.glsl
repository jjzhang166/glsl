#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	float d = -p.x * sign(p.y) + p.y * sign(p.x);
	
	vec4 kRed = vec4( 204.0 / 255.0, 0.0, 0.0, 1.0 );
	vec4 kWhite = vec4( 1.0, 1.0, 1.0, 1.0 );
	vec4 kBlue = vec4( 0.0, 0.0, 102.0 / 255.0, 1.0 );
	
	if((abs(p.x) < (6.0/60.0)) || (abs(p.y) < (6.0/30.0)))
	{
		gl_FragColor = kRed;
	}
	else 
	if((abs(p.x) < (10.0/60.0)) || (abs(p.y) < (10.0/30.0)))
	{
		gl_FragColor = kWhite;
	}
	else 
	if( (d > 0.0)  && (d < 0.15))
	{
		gl_FragColor = kRed;
	}
	else
	if( (d > -0.15 * 3.0 / 2.0)  && (d < 0.15 * 3.0 /2.0))
	{
		gl_FragColor = kWhite;
	}
	else
	{
		gl_FragColor = kBlue;
	}
}