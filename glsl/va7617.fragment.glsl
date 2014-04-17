#ifdef GL_ES
precision mediump float;
#endif

//American Flag
//by Nick Powers

uniform float time;
uniform vec2 resolution;

uniform vec2 surfaceSize;
varying vec2 surfacePosition;

const float PI = 3.141592653589793238462643383279502884197169399;
const float PI_HALF = PI * 0.5;
const float PI_2 = PI * 2.0;
const float PI10 = PI / 5.0;
const float PI5 = PI / 2.5;
const float PI20 = PI / 10.0;

const float STRIPE_SIZE = 2.0 * (1.0 / 13.0);
const float STRIPE_MOD = STRIPE_SIZE * 0.5;

const float STAR_X = 0.063 * 2.0;
const float STAR_MOD_X = 0.063;
const float STAR_Y = 0.054 * 2.0;
const float STAR_MOD_Y = 0.054;
const float STAR_SLOPE = STAR_MOD_Y / STAR_MOD_X;
const float STAR_SLOPE_NEG = 0.0 - STAR_SLOPE;

const float D = 0.76;
const float C = 1.0 - (7.0 / 13.0);
const float INV_B = 1.0 / 1.9;

float clip = (resolution.y / resolution.x) * 1.9;

vec4 getStripeColor(vec2 position)
{
	float temp = mod(position.y, STRIPE_SIZE);
	
	if(temp < STRIPE_MOD)
	{
		return vec4(1, 0, 0, 1.0 );
	}
	else
	{
		return vec4(1, 1, 1, 1.0 );
	}
}

float getAngle(vec2 v)
{
	v = normalize(v);
	
	if(v.y > 0.0)
		return acos(v.x);
	else
		return PI_2 - acos(v.x);
}

vec2 getVector(float angle, float leng)
{
	return vec2(cos(angle), sin(angle)) * leng;
}

vec4 getStarColor(vec2 position)
{
	position -= vec2(STAR_MOD_X, STAR_MOD_Y);
	
	float u = floor((STAR_MOD_X + position.x - (1.0 / STAR_SLOPE * position.y)) / STAR_X);
	float v = floor((STAR_MOD_Y + position.y + (STAR_SLOPE * position.x)) / STAR_Y);
	
	float v0 = v - u;
	float u0 = u + v;
	
	if(u0 >= 0.0 && u0 <= 10.0 && v0 >= 0.0 && v0 <= 8.0)
	{
		position -= vec2(u0 * STAR_MOD_X, v0 * STAR_MOD_Y);
		
		//float color = 0.0616 * 0.5;
		if(length(position) < 0.0616 * 0.5)
		{
			float angle = PI10 - abs(mod(getAngle(position)-PI_HALF, PI5) - PI10);
			
			vec2 temp0 = getVector(angle, length(position));
			
			const float CONSTANT = 0.0616 * 0.5;
			const float SLOPE = -(-0.58778525229247312916870595463907 * CONSTANT * 14.0) / (CONSTANT - (0.80901699437494742410229341718282));
			const float YINTERCEPT = -CONSTANT * SLOPE;
			
			if(temp0.y < (temp0.x * SLOPE) + YINTERCEPT)
				return vec4(1,1,1,1);
		}
		
	}
	
	return vec4(0,0,1,1);
}
vec4 getFlagColor(vec2 position)
{
	bool bool0 = position.y > C;
	bool bool1 = position.x > D;
	
	if(bool0)
		if(bool1)
			return getStripeColor(position);
		else
			return getStarColor(position - vec2(0.0, C));
	else
		if(bool1)
			return getStripeColor(position);
		else
			return getStripeColor(position);
			
	
	
}

void main( void ) {

	vec2 position = ((gl_FragCoord.xy / resolution) * length(surfaceSize)) + surfacePosition;
	
	//position.y += sin(10.0 * position.x + time) * 0.1;
	
	bool bool0 = position.x < clip;
	
	position.x /= clip;
	
	
	if(bool0 && position.y > 0.0 && position.y < 1.0 && position.x > 0.0)
		gl_FragColor = getFlagColor(position * vec2(1.9, 1.0));
			
}