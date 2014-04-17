//  Denmark!
//  by @dennishjorth
//
//  Please! Set the precision to 0.5!
//  otherwise it hurts your eyes...
// ....here you go, now it's actually fast enough to run at 0.5... :p DON'T USE CONDITIONALS

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	float d = -p.x * sign(p.y) + p.y * sign(p.x);
		
	vec2 tt = 0.1 * vec2( -cos(-time*2.0 - p.y*2.00),
			      -cos(-time*2.5 + p.x*2.75) );
	
	vec2 at = abs( p + vec2(0.3,0) + tt );
	float stepped = step( 6.0/60.0, at.x ) * step(6.0/30.0, at.y);
	
	vec4 kRed = vec4( 255.0 / 255.0, 0.0, 0.0, 1.0 );
	vec4 kWhite = vec4( 1.0, 1.0, 1.0, 1.0 );
	gl_FragColor = mix( kWhite, kRed, stepped );
}