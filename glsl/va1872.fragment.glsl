/*
	A mandlebrot/julia set renderer
	try tracing the outline of the mandlebrot that you can view through the julia, to see twirly patterns
	Original by @tenpn, modified by @emackey.

	**  ---- NEW FEATURE ----
	**
	**  1. Click 'hide code' to allow your mouse to click on the background.
	**
	**  2. Click-and-drag the LEFT mouse button to pan the virtual surface.
	**
	**  3. Click-and-drag the RIGHT mouse button to zoom the virtual surface.
	**
	**  4. Hold SHIFT and click either mouse button to return to the default location.
	**
*/

#ifdef GL_ES
// Use mediump for better compatibility with mobile.  Desktops will use highp regardless.
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// NEW: This 'uniform' vec2 indicates the size of the visible area of the virtual surface.
uniform vec2 surfaceSize;
// NEW: This 'varying' vec2 indicates the position of the current fragment on the virtual surface.
varying vec2 surfacePosition;
// You are encouraged to add the above values to your own shaders, see recommended usage below.

float isInMandlebrot(vec2 complexCoord, vec2 additionalTerm)
{
	const int maxIterations = 200;
	
	vec2 z = complexCoord;
	for(int itIndex = 0; itIndex < maxIterations; ++itIndex)
	{	
		float zRealSq = z.x*z.x;
		float zImSq = z.y*z.y;
		if ((zRealSq + zImSq) > 4.0)
		{
			return pow(float(itIndex)/float(maxIterations), 0.8);
		}
		z.y = 2.0*z.x*z.y + additionalTerm.y;
		z.x = zRealSq - zImSq + additionalTerm.x;
	}
	
	return 1.0;
}

void main( void ) 
{
	// "Virtual Surface" usage instructions:
	
	// Many legacy shaders use math along the lines of ( gl_FragCoord.xy / resolution.xy )
	// to compute a varying fragment position in the range [0, 1].  Typically this portion of the
	// math can be replaced by "surfacePosition" to use the virtual surface position instead.
	// Additionally, math to shift position based on mouse location can be dropped, as the
	// surface is interactively positioned by the user.  Also, aspect ratio code such as
	// ( resolution.x / resolution.y ) can be dropped, because the virtual surface does
	// window aspect ratio correction on its own.
	
	// The default Y range is [-1, 1] with 0 in the center.  The default X range also
	// places 0 in the center, but the edges of the X range fit to the shape of the window.
	// So, default X = [ -resolution.x / resolution.y, resolution.x / resolution.y ]
	
	// The defaults can be changed easily.  For example, the Mandelbrot here uses
	// twice the default range, with X shifted -0.5, like this:

	vec2 position = surfacePosition * 2.0 - vec2(0.5, 0.0);

	// The mouse's position on the virtual surface may be computed using a vector from the
	// fragment position to the normalized mouse position, like this:
	
	vec2 mousePosition = (mouse - ( gl_FragCoord.xy / resolution )) * surfaceSize + surfacePosition;

	// The mouse needs the same default range shifting that we gave to the fragment position:
	
	mousePosition = mousePosition * 2.0 - vec2(0.5, 0.0);

	// Now compute a nice fractal.
	
	vec4 blue   = vec4( 0.1, 0.28, 0.67, 1.0);
	vec4 orange = vec4( 1.0, 0.67, 0.0, 1.0);

	float julia = isInMandlebrot(position, mousePosition);
	float mandelbrot = isInMandlebrot(position, position);

	gl_FragColor = (blue * (1.0 - mandelbrot) + orange * mandelbrot) * (julia * 0.9 + 0.1);
	
	// Setting the alpha value to 1.0 helps the gallery screenshot work on more hardware.
	gl_FragColor.a = 1.0;
}