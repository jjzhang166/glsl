#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define speed 0.025

/*
 * Basic tunnel effect.
 * Thanks to Adrian Boeing for his tutorial at http://adrianboeing.blogspot.com.ar/2011/01/webgl-tunnel-effect-explained.html
 * some modifications by epyx
 */

float getCheckerboardColor( vec2 position ) {
	float  xpos = floor( 40.0 * position.x );
	float  ypos = floor( 05.0 * position.y );
	float col = mod( xpos, 2.0 );
	if( mod( ypos, 2.0 ) > 0.0 ) {
		if( col > 0.0 ) col = 0.2;	
		else col = 1.0;
	}
	return col;
}

void main( void ) {

	// Normalize coords from 0->1 with 0.5, 0.5 at center.
	vec2 position = 2.0 * gl_FragCoord.xy / resolution.xy - 1.00;
	position.x += 2.0 * ( mouse.x - 0.5 );
	position.y += 2.0 * ( mouse.y - 0.5 );
	position.x *= resolution.x / resolution.y; // Correct aspect ratio.

	// Cartesian coords to polar coords.
	float a = atan( position.y, position.x );
	float r = length( (position)* 1.);
	

	vec2 p = vec2( 0.1 / r + speed * time, ( a - ( sin(time)*(speed/2.) ) * time ) / 3.1416 );
	float texSample = getCheckerboardColor( p );
	
	// Use r to create a little distance fog.
	gl_FragColor = vec4( vec3( r * (texSample*sin(time/10.) ) , r * (texSample*cos(time/10.) ) , r * (texSample*sin(time/5.) ) ), 1.0 );

}