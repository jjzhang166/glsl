/*
	A mandlebrot/julia set renderer
	try tracing the outline of the mandlebrot that you can view through the julia, to see twirly patterns

	by @tenpn

	folded in some improvements from @emackey
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 normalisedPosToComplexCoord(vec2 normalisedPos)
{
	const float minReal = -2.0;
	const float maxReal = 1.0;
	const float realWidth = maxReal - minReal;
	
	const float minImaginary = -1.2;
	float maxImaginary = minImaginary 
		+ realWidth*(resolution.y/resolution.x);
	float imaginaryWidth = maxImaginary - minImaginary;
	
	return vec2(normalisedPos.x * realWidth + minReal,
		    normalisedPos.y * imaginaryWidth + minImaginary);
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
	
	// center of screen is 0,0
	vec2 complexCoord = screenToComplexCoord( gl_FragCoord.xy );
	
	// draw a dynamic julia
	vec2 additionalTerm = normalisedPosToComplexCoord(mouse); // complexCoord; (for standard mandlebrot)
	
	const vec4 mandlebrotCol = vec4( 1.0, 0.60, 0.0, 1.0);
	const vec4 juliaCol = vec4( 0.06, 0.28, 0.66, 1.0);
	
	float juliaSetProp = isInMandlebrot(complexCoord, additionalTerm);
	
	if(juliaSetProp == 1.0)
	{
		float mandlebrotProp = isInMandlebrot(complexCoord, complexCoord);
		if(mandlebrotProp == 1.0)
		{
			gl_FragColor = mandlebrotCol;
		}
		else
		{
			gl_FragColor = juliaCol*(1.0-mandlebrotProp) + mandlebrotCol*mandlebrotProp;
		}
	}
	else
	{
		gl_FragColor = juliaCol * juliaSetProp;
	}
	
	gl_FragColor.a = 1.0;

}