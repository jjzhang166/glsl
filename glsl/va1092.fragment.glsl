// flames - @P_Malin
 
// note - intensity stored in the backbuffer alpha channel 
//    hmm, alpha channel = an interesting new place to keep state!
 
#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 resolution;
 
uniform sampler2D backbuffer;
 
// get backbuffer alpha channel from pixel coordinates
float SampleBackbuffer( vec2 vCoord )
{
	return texture2D(backbuffer, vCoord / resolution.xy).a;
}
 
// simply average pixels surrounding vCoord
float GetIntensityAverage( vec2 vCoord )
{
	float fDPixel = 1.0;
	
	float fResult 	= SampleBackbuffer( vCoord + vec2(0.0, 0.0) )
			+ SampleBackbuffer( vCoord + vec2( fDPixel, 0.0) )
		      	+ SampleBackbuffer( vCoord + vec2(-fDPixel, 0.0) )
			+ SampleBackbuffer( vCoord + vec2(0.0,  fDPixel) )
			+ SampleBackbuffer( vCoord + vec2(0.0, -fDPixel) );
	
	return fResult / 5.0;       
}
 

vec2 GetIntensityGradient(vec2 vCoord)
{
	float fDPixel = 1.0;
	
	float fPX = SampleBackbuffer(vCoord + vec2( fDPixel, 0.0));
	float fNX = SampleBackbuffer(vCoord + vec2(-fDPixel, 0.0));
	float fPY = SampleBackbuffer(vCoord + vec2(0.0,  fDPixel));
	float fNY = SampleBackbuffer(vCoord + vec2(0.0, -fDPixel));
	
	return vec2(fPX - fNX, fPY - fNY);              
}

vec3 GetColour( float fIntensity )
{
	return vec3(1.0, 0.4, 0.0) * fIntensity * 3.0;
}

void main( void )
{
	vec2 vCoord = gl_FragCoord.xy;
	
	// get the intensity at the current pixel
	float fCurrPixelValue = SampleBackbuffer(vCoord);
	
	vec2 vFlamePos = vCoord;
	
	// move 'down' more the 'hotter' the pixel we sampled was
	// this is the main trick to get flame effect looking interesting
	vFlamePos.y -= fCurrPixelValue * 32.0;
	
	// always sample at least one pixel below
	vFlamePos.y -= 1.0;
	
	// move down the intensity gradient
	// (not really necessary for effect but gives the flames some sideways movement + a better shape)
	vFlamePos -= GetIntensityGradient(vCoord) * 10.0; 
	
	// average the surrounding pixels at the new position
	float fIntensity = GetIntensityAverage(vFlamePos);
	
	// fade
	fIntensity *= (253.0 / 256.0);
	fIntensity -= (1.0 / 256.0);
	
	// "random" junk in the bottom few pixels
	if(gl_FragCoord.y < 2.0)
	{
		fIntensity = fract(sin(fract(time + gl_FragCoord.x * 124.1231243) * 32.3242 + sin(time * 23.234234 + gl_FragCoord.x * 1.451243)));
	}
	
	vec3 vCol = GetColour(fIntensity);
	
	gl_FragColor = vec4(vCol, fIntensity);
}