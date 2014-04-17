// Modified to follow mouse

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define speed 0.25

/*
 * Basic tunnel effect.
 * Thanks to Adrian Boeing for his tutorial at http://adrianboeing.blogspot.com.ar/2011/01/webgl-tunnel-effect-explained.html
 */

float getCheckerboardColor( vec2 position ) {
	float  xpos = floor( 20.0 * position.x );
	float  ypos = floor( 10.0 * position.y );
	float col = mod( xpos, 2.0 );
	if( mod( ypos, 2.0 ) > 0.0 ) {
		if( col > 0.0 ) col = 0.0;	
		else col = 1.0;
	}
	return col;
}

void main( void ) {

	// Normalize coords from 0->1 with 0.5, 0.5 at center.
	vec2 position = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	position.x += 2.0 * (0.5 - mouse.x );
	position.x *= resolution.x / resolution.y; // Correct aspect ratio
	position.y += 2.0 * (0.5 - mouse.y );
	
	// Cartesian coords to polar coords.
	float a = atan( position.y, position.x );
	float r = length( position );
 //r = -r * sin( a ); // This would create a plane instead of a tunnel.
	
	// Use the coordinates to read from a texture.
	// If we normalize a from 0->1, we can use r and a to "radially" read the image. 
	// If instead we use 1/r, we can simulate depth.
	//vec2 p = vec2( 0.1 / r, a / 3.1416 );
	vec2 uv = vec2( 0.1 / r + speed * time, ( a + speed * time ) / 3.1416 );
	float texSample = getCheckerboardColor( uv );
	
	// Use r to create a little distance fog.
	gl_FragColor = vec4( vec3( r * texSample ), 1.0 );

}