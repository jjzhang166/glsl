//  Denmark!
//  by @dennishjorth
//
//  Please! Set the precision to 0.5!
//  otherwise it hurts your eyes...

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	float d = -p.x * sign(p.y) + p.y * sign(p.x);
	
	vec4 kRed = vec4( 255.0 / 255.0, 0.0, 0.0, 1.0 );
	vec4 kWhite = vec4( 1.0, 1.0, 1.0, 1.0 );
	
	float ttx = -cos(-time*2.0-p.y*2.00)*0.1;
	float tty = -cos(-time*2.5+p.x*2.75)*0.1;
	
	if((abs(p.x+0.3+ttx) < (6.0/60.0)) || (abs(p.y+tty) < (6.0/30.0)))
	{
		gl_FragColor = kWhite;
	}
	else
	{
		gl_FragColor = kRed;
	}
}