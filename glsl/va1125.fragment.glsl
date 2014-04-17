// Bouncing Ball - @P_Malin
//
// 	Ball is pushed away from mouse
// 	Move mouse to top of window to reset
 
// 	The ball state is encoded in the backbuffer alpha channel
 
#ifdef GL_ES
precision highp float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
uniform sampler2D backbuffer;
 
#define kElasticity 0.8
#define kGravity 0.00025
#define kDamping 0.999995
#define kBorder 0.025
 
#define STATE_INDEX_BALL_VEL_X 0.0
#define STATE_INDEX_BALL_VEL_Y 1.0
#define STATE_INDEX_BALL_POS_X 2.0
#define STATE_INDEX_BALL_POS_Y 3.0
#define STATE_INDEX_COUNT 4.0

struct C_State
{
	vec2 vBallPos;
	vec2 vBallVel;
};

// We use two elements per variable a low and high byte
#define kElementsPerVariable 2.0
	
// we store the same state stretched across several pixels and sample from the centre of this block (in case there is any filtering and for 0.5 mode)
#define kVariableStretch 8.0
 
float SampleBackBuffer( const in vec2 vPosition )
{
	return texture2D(backbuffer, vPosition / resolution).a;
}
 
float FramebufferToByte( const in float fByte )
{
	return fByte * 255.0;
}

float ByteToFramebuffer( const in float fByte )
{
	return fByte / 255.0;
}

float UnsignedVariableToStorage( const in float fX )
{
	return fX * 65535.0;
}

float UnsignedStorageToVariable( const in float fX )
{
	return fX / 65535.0;
}

float SignedVariableToStorage( const in float fX )
{
	return UnsignedVariableToStorage(fX * 0.5 + 0.5);
}

float SignedStorageToVariable( const in float fX )
{
	return UnsignedStorageToVariable(fX) * 2.0 - 1.0;
}

float GetVariable( const in float fIndex )
{
	float fVariablePos = fIndex * kVariableStretch * kElementsPerVariable + (kVariableStretch/2.0); // sample in the middle of the stretched block
       
	float fLow = FramebufferToByte(SampleBackBuffer( vec2(fVariablePos, kVariableStretch/2.0) ) );
	float fHigh = FramebufferToByte(SampleBackBuffer( vec2(fVariablePos + kVariableStretch, kVariableStretch/2.0) ) );
	
	return ( fLow + fHigh * 256.0 );
}

float EvaluateVariable( const in C_State state, const in float fIndex )
{             
	if(fIndex < (STATE_INDEX_BALL_VEL_X + 0.5))
	{
		return SignedVariableToStorage(state.vBallVel.x);
	}
	else
	if(fIndex < (STATE_INDEX_BALL_VEL_Y + 0.5))
	{
		return SignedVariableToStorage(state.vBallVel.y);
	}
	else
	if(fIndex < (STATE_INDEX_BALL_POS_X + 0.5))
	{
		return UnsignedVariableToStorage(state.vBallPos.x);
	}
	else               
	{
		return UnsignedVariableToStorage(state.vBallPos.y);
	}
}

float EvaluateStateStoreForCurrentPixel( const in C_State newState )
{	
	if( gl_FragCoord.y > kVariableStretch )
	{
		return 1.0;
	}
               
	float fVariableStorePos = floor(gl_FragCoord.x / kVariableStretch);

	float fVariableIndex = floor(fVariableStorePos / kElementsPerVariable);
	if( fVariableIndex > (STATE_INDEX_COUNT - 0.5) )
	{
		return 1.0;
	}
	
	float fVariablePart = mod(fVariableStorePos, kElementsPerVariable);

	float fVariableValue = floor(EvaluateVariable(newState, fVariableIndex));
		       
	if( fVariablePart < 0.5 )
	{
		// store low byte
		return ByteToFramebuffer(mod(fVariableValue, 256.0));
	}
	else
	if( fVariablePart < 1.5 )
	{
		// store high byte
		return ByteToFramebuffer(floor(fVariableValue / 256.0));
	}
	else
	{
		return 1.0;
	}
}

void GetStoredState( out C_State state )
{
	state.vBallPos = vec2(UnsignedStorageToVariable(GetVariable(STATE_INDEX_BALL_POS_X)), UnsignedStorageToVariable(GetVariable(STATE_INDEX_BALL_POS_Y)));
	state.vBallVel = vec2(SignedStorageToVariable(GetVariable(STATE_INDEX_BALL_VEL_X)), SignedStorageToVariable(GetVariable(STATE_INDEX_BALL_VEL_Y)));
} 

float InResetArea( const in vec2 vCoord )
{
	if(time < 1.0)
	{
		return 0.0;
	}
	
	if(vCoord.y > 0.92)
	{
		return 1.0;
	}
	
	return -1.0;        
}
 
float ResetState()
{
	return InResetArea(mouse);
}
 
vec2 GetAccel( const in C_State state )
{
	vec2 vBallPos = state.vBallPos;
	vec2 vDelta = mouse - vBallPos;
	vDelta.y *= resolution.y / resolution.x;
	
	float fDist = length(vDelta);
	vec2 vDir = normalize(vDelta);
	
	float fMaxRadius = 0.05;
	float fMag = min(fDist / fMaxRadius, 1.0);

	return -vDir * (1.0 - fMag) * 0.001;
}
 
void UpdateState( const in C_State oldState, out C_State newState )
{
	
	newState.vBallVel = oldState.vBallVel;
	newState.vBallVel += vec2(0.0, -kGravity);
	newState.vBallVel *= kDamping;
	newState.vBallVel += GetAccel(oldState);
	
	float fAspectRatio = resolution.x / resolution.y;
	
	// bounce
	vec2 vNewPos = oldState.vBallPos + newState.vBallVel;	
	if(vNewPos.x > (1.0 - kBorder))
	{
		newState.vBallVel.x = -abs(newState.vBallVel.x) * kElasticity;
	}
	if(vNewPos.x < kBorder)
	{
		newState.vBallVel.x = abs(newState.vBallVel.x) * kElasticity;
	}
	if(vNewPos.y > (1.0 - kBorder * fAspectRatio))
	{
		newState.vBallVel.y = -abs(newState.vBallVel.y) * kElasticity;
	}
	if(vNewPos.y < kBorder * fAspectRatio)
	{
		newState.vBallVel.y = abs(newState.vBallVel.y) * kElasticity;
	}
	
	// set new position
	newState.vBallPos = oldState.vBallPos + newState.vBallVel;
	
	if( ResetState() > 0.0 )
	{
		newState.vBallPos = vec2(0.5, 0.5);
		newState.vBallVel = vec2(0.01, 0.01);
	}
	
	newState.vBallPos = clamp(newState.vBallPos, 0.0, 1.0);
	newState.vBallVel = clamp(newState.vBallVel, -1.0, 1.0);
	
	if( ResetState() > 0.0 )
	{
		newState.vBallPos = vec2(0.5, 0.5);
		newState.vBallVel = vec2(0.005, 0.015);
	}
}

void main( void ) 
{ 
	vec2 vPos = ( gl_FragCoord.xy / resolution.xy );
	
	C_State oldState;
	GetStoredState(oldState);
	
	C_State newState;
	UpdateState(oldState, newState);
	
	float fPixelStore = EvaluateStateStoreForCurrentPixel( newState );
		
	vec2 vDelta = (newState.vBallPos) - vPos;
	vDelta.y *= resolution.y / resolution.x;
	float fDist = length(vDelta);
	
	vec3 vColour = mix(vec3(0.0, 0.4, 0.3), vec3(0.0, 0.0, 0.4), vPos.y);
	
	// draw reset area
	if( InResetArea(vPos) > 0.0 )
	{
		vColour = vec3(0.5);
	}
	
	// uncomment this line to render state encoding to screen
	//vColour = mix(vColour, vec3(1.0, 0.0, 0.0), fPixelStore);
	
	// uncomment this section to render last position (debug velocity)
	//vec2 vBallMove = newState.vBallPos - newState.vBallVel;
	//vec2 vBallMoveDelta = (vBallMove - vPos);
	//vBallMoveDelta.y *= resolution.y / resolution.x;
	//if(length(vBallMoveDelta) < 0.025)
	//{
	//	vColour = vec3(0.0, 0.0, 1.0);
	//}
	
	// draw ball
	float fRadius = 0.025;
	if(fDist < fRadius)
	{
		float r = fDist / fRadius;
		float h = sqrt(1.0 - r * r);
		vec3 vNormal = vec3(normalize(vDelta) * r, h);
	       
		vec3 vLight = normalize(vec3(1.0, -1.0, 1.0));
		float fDiffIntensity = max(0.0, dot(vNormal, vLight));
		vColour = vec3( 1.0, 1.0, 0.0 ) * (fDiffIntensity + 0.3);
	}
	
	vColour = max(vColour, texture2D(backbuffer, vPos).xyz * 0.95);
	
	gl_FragColor = vec4( vColour, fPixelStore );
}