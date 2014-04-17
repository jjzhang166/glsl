#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// NEW: This 'uniform' vec2 indicates the size of the visible area of the virtual surface.
uniform vec2 surfaceSize;
// NEW: This 'varying' vec2 indicates the position of the current fragment on the virtual surface.
varying vec2 surfacePosition;

float isInMandlebrot(vec2 complexCoord, vec2 additionalTerm)
{
	const int maxIterations = 300;
	
	vec2 z = complexCoord;
	for(int itIndex = 0; itIndex < maxIterations; ++itIndex)
	{	
		float zRealSq = z.x*z.x;
		float zImSq = z.y*z.y;
		if ((zRealSq + zImSq) > 8.0)
		{
			return pow(float(itIndex)/float(maxIterations), 0.9);
		}
		z.y = 2.0*z.x*z.y + additionalTerm.y;
		z.x = zRealSq - zImSq + additionalTerm.x;
	}
	
	return 1.0;
}

void main( void ) {

	vec2 position = surfacePosition * 1.0;

	// The mouse's position on the virtual surface may be computed using a vector from the
	// fragment position to the normalized mouse position, like this:
	
	vec2 mousePosition = (mouse - ( gl_FragCoord.xy / resolution )) * surfaceSize + surfacePosition;

	// The mouse needs the same default range shifting that we gave to the fragment position:
	
	mousePosition = mousePosition * 1.0 -vec2(0.5,0.0);
	
	float color = isInMandlebrot(position, mousePosition);
	

	gl_FragColor = vec4( 2.2 * (color * (abs(sin(time/3.0)) + 1.0)), 2.1 * clamp(0.0,1.0,color + cos(time/2.0) -1.0), 7.1 * clamp(0.0,1.0, color + sin(time/4.0) - 1.0) , 1.0 );

}