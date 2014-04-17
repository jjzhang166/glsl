#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void drawFormula( float left, float right, float res, vec3 color )
{	
	if ( abs( left - right ) < res*40.0 ) {
		gl_FragColor = vec4( color, 1.0 );	
	}
}

void main( void )
{
	// Settings/preparations
	float minX = -16.0;
	float minY = -10.0;
	float maxX = 16.0;
	float maxY = 10.0;
	float x = (gl_FragCoord.x/resolution.x)*(maxX-minX)+minX;
	float y = (gl_FragCoord.y/resolution.y)*(maxY-minY)+minY;
	float res = 2.0/(resolution.x+resolution.y);
	
	// White background
	gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
	
	// y = x^2
	drawFormula( y, x*x*x, res*(1.0+abs(y))/2.5, vec3( 0.0, 1.0, 0.0 ) );
	// y = sqrt( x )
	drawFormula( y, sqrt(x), res*(5.0+abs(y))/8.0, vec3( 0.0, 0.0, 1.0 ) );
	// x^2 + y^2 = 9
	drawFormula( x*x + y*y, 9.0, res*(2.0+abs(y)), vec3( 0.0, 0.0, 0.0 ) );
	
	// Axes
	if ( abs( y ) < res*20.0 ) gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
	if ( abs( x ) < res*20.0 ) gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}