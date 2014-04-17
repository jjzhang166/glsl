// Conway's Game of Life - @P_Malin
// Maze variation by WhyNot
// http://en.wikipedia.org/wiki/Conway's_Game_of_Life

// move mouse to top of screen for randomness

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// blocksize can be 1 but not if resolution set to 0.5
#define kBlockSize 1.0
#define kBlockSizeDiv2 (kBlockSize/2.0)

float rand( const in vec2 v )
{
	float value = fract( sin(time + v.x * 1014.43572) * 31344.234 + atan(time + v.y * 3442.43572,sin(time + v.x * 1014.43572)) * 543.234);
	
	return value;
}

float SampleBackbuffer(const in vec2 vPos)
{
	float fSample = texture2D(backbuffer, fract(vPos / resolution)).a;
	return step(0.5, fSample);
}

vec2 GetBlockCentre( const in vec2 vPos )
{
	return floor(vPos / kBlockSize) * kBlockSize + kBlockSizeDiv2;
}

void main( void ) 
{
	vec2 vCoord = GetBlockCentre(gl_FragCoord.xy);

	float fNeighbourCount 	= SampleBackbuffer( vCoord + vec2(-kBlockSize,	-kBlockSize) )
				+ SampleBackbuffer( vCoord + vec2( 0.0,		-kBlockSize) )
				+ SampleBackbuffer( vCoord + vec2( kBlockSize,	-kBlockSize) )
				
				+ SampleBackbuffer( vCoord + vec2(-kBlockSize, 	0.0) )
				+ SampleBackbuffer( vCoord + vec2( kBlockSize, 	0.0) )
					
				+ SampleBackbuffer( vCoord + vec2(-kBlockSize, 	kBlockSize) )
				+ SampleBackbuffer( vCoord + vec2( 0.0, 	kBlockSize) )
				+ SampleBackbuffer( vCoord + vec2( kBlockSize, 	kBlockSize) );
	
	float fCellState = SampleBackbuffer( vCoord + vec2( 0.0, 0.0) );
	
	float fAlive = 0.0;
	if(fCellState > 0.5)
	{
		if((fNeighbourCount > 1.9) && (fNeighbourCount < 4.1))
		{
			fAlive = 1.0;
		}
	}
	else
	{
		if((fNeighbourCount > 2.9) && (fNeighbourCount < 3.1))
		{
			fAlive = 1.0;
		}
	}
	
	// set to be random if mouse at top of screen
	if((mouse.y > 0.9) || (time < 1.0))
	{
		fAlive = step(0.5, rand(vCoord));
	}
	
	vec3 vBack = vec3(0.0, 0.0, 0.3) + rand(gl_FragCoord.xy) * vec3(0.0, 0.2, 0.2);
	float fDist = length((gl_FragCoord.xy / resolution) * 2.0 - 1.0);
	vBack  *= clamp(1.0 - fDist * 0.5, 0.0, 1.0);
	vec3 vResult = mix( vBack, vec3(1.0, 0.5, 0.0), fAlive );

	gl_FragColor = vec4( vResult, fAlive );

}