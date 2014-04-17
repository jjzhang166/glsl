/*
	A mandlebrot/julia set render
	tweak the additionalTerm variable to change between mandlebrot and 
		a given julia set.
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 screenToComplexCoord(vec2 screenCoord)
{
	const float minReal = -2.0;
	const float maxReal = 1.0;
	const float realWidth = maxReal - minReal;
	
	const float minImaginary = -1.2;
	float maxImaginary = minImaginary 
		+ realWidth*(resolution.y/resolution.x);
	float imaginaryWidth = maxImaginary - minImaginary;
	
	vec2 normalisedPos 
		= ( screenCoord / resolution.xy );
	
	return vec2(normalisedPos.x * realWidth + minReal,
		    normalisedPos.y * imaginaryWidth + minImaginary);
}

bool isInMandlebrot(vec2 complexCoord, out float resultProgress, vec2 additionalTerm)
{
	const int maxIterations = 50;
	
	vec2 z = complexCoord;
	for(int itIndex = 0; itIndex < maxIterations; ++itIndex)
	{	
		float zRealSq = z.x*z.x;
		float zImSq = z.y*z.y;
		if ((zRealSq + zImSq) > 4.0)
		{
			resultProgress = float(itIndex)/float(maxIterations);
			return false;
		}
		z.y = 2.0*z.x*z.y + additionalTerm.y;
		z.x = zRealSq - zImSq + additionalTerm.x;
	}
	
	resultProgress = 1.0;
	return true;
}

void main( void ) 
{
	
	// center of screen is 0,0
	vec2 complexCoord = screenToComplexCoord( gl_FragCoord.xy );
	
	float resultProgress;
	// draw a dynamic julia
	vec2 additionalTerm = mouse  + (sin(time + sqrt(time) )); //(for standard mandlebrot)
	
	if(isInMandlebrot(complexCoord, resultProgress, additionalTerm))
	{
		gl_FragColor = vec4( 0.06, 0.28, 0.66, 1.0);
	}
	else
	{
		gl_FragColor = vec4( resultProgress, resultProgress, resultProgress, 1.0);
	}

}