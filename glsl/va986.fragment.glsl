#ifdef GL_ES
precision highp float;
#endif



uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float 	kColourEpsilon  = 0.001;

float 	kBottomBorder 	= 0.01;
float 	kTopBorder 	= 0.99;


float 	kShotSize 	= 0.02;


vec3 	kUnitialised 	= vec3(0.0, 0.0, 0.0);
vec3 	kSpace 		= vec3(0.3, 0.3, 0.3);
vec3 	kShot 		= vec3(0.9, 0.0, 0.0);


// State detection /////////////////////////

bool IsUninitialized(vec3 color) 
{
	return (color == kUnitialised);
}

bool IsShot(vec3 color) 
{
	return (color == kShot);
}

////////////////////////////////////////////

bool IsShotFired(float x, float y, float pixelX, float pixelY)
{
	if ( y < kShotSize )
	{
		return true;	
	}
	
	return false;
}	

/////////////////////////////////////////////

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixelUV = 1./resolution;
	vec2 mousepx = mouse * pixelUV;

	vec4 oldColour = texture2D(backbuffer, position);
	vec4 newColour = vec4(kSpace.r, kSpace.g, kSpace.b, 1.0);

	
	if ( IsShotFired(position.x, position.y, pixelUV.x, pixelUV.y) )
	{
		// new shot fired
		newColour.rgb = kShot;
	}
	else 
	{
		// move shots along
		// detect collisions between shots and asteroids
		// when a collision has occured explode the asteroid and remove shot
		
		float shoty = position.y - kShotSize;
		vec4 below = texture2D( backbuffer, vec2(position.x + (pixelUV.x/2.), shoty + (pixelUV.y/2.)) );
		
		if ( IsShot(below.rgb) ) 
		{
			// Move shot up
			newColour.rgb = kShot;
		}
	}
		
	
	gl_FragColor = newColour;
}