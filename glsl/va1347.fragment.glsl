/*
	A mandlebrot/julia set renderer
	try tracing the outline of the mandlebrot that you can view through the julia, to see twirly patterns

	Original by @tenpn
	Modified by @emackey to make the code a little simpler, fractal more centered etc.
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 normalisedPosToComplexCoord(vec2 normalisedPos)
{
	vec2 complexCoord = (normalisedPos - 0.5) * 2.0;
	complexCoord.x = (complexCoord.x - 0.3333) * resolution.x / resolution.y;

	return complexCoord;
}

vec2 screenToComplexCoord(vec2 screenCoord)
{	
	vec2 normalisedPos 
		= ( screenCoord / resolution.xy );
	return normalisedPosToComplexCoord(normalisedPos);
}

float isInMandlebrot(vec2 complexCoord, vec2 additionalTerm)
{
	const int maxIterations = 50;
	
	vec2 z = complexCoord;
	for(int itIndex = 0; itIndex < maxIterations; ++itIndex)
	{	
		float zRealSq = z.x*z.x;
		float zImSq = z.y*z.y;
		if ((zRealSq + zImSq) > 4.0)
		{
			return float(itIndex)/float(maxIterations);
		}
		z.y = 2.0*z.x*z.y + additionalTerm.y;
		z.x = zRealSq - zImSq + additionalTerm.x;
	}
	
	return 1.0;
}

void main( void ) 
{
	vec2 complexCoord = screenToComplexCoord( gl_FragCoord.xy );
	
	// draw a dynamic julia
	vec2 additionalTerm = normalisedPosToComplexCoord(mouse);

	vec4 juliaCol      = vec4( 0.1, 0.28, 0.67, 1.0);
	vec4 mandelbrotCol = vec4( 1.0, 0.67, 0.0, 1.0);

	float julia = isInMandlebrot(complexCoord, additionalTerm);
	float mandelbrot = isInMandlebrot(complexCoord, complexCoord);

	gl_FragColor = (juliaCol * (1.0 - mandelbrot) + mandelbrotCol * mandelbrot) * (julia * 0.9 + 0.1);
	gl_FragColor.a = 1.0;
}