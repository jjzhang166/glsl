/*
twitter: @eddietree

Perlin noise implementation
with accumulation to create the 
water color effect
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float Noise(float x, float y) 
{
	return fract(sin(dot(vec2(x,y) ,vec2(12.9898,78.233))) * 43758.5453);
}

float CosineInterp( float a, float b, float x )
{
	float ft = x * 3.1415927;
	float f = (1.0 - cos(ft)) * 0.5;
	return  a * ( 1.0 - f ) + b * f;
}


float SmoothNoise( float x, float y )
{
	float corners = ( Noise((x-1.0), (y-1.0))+Noise((x+1.0), (y-1.0))+Noise((x-1.0), (y+1.0))+Noise((x+1.0), (y+1.0)) ) * 0.0625;
	float sides   = ( Noise((x-1.0), (y))  +Noise((x+1.0), (y))  +Noise((x), (y-1.0))  +Noise((x), (y+1.0)) ) * 0.1025;
	float center  =  Noise((x), (y)) * 0.25;
	return corners + sides + center;
}

float InterpNoise(float x, float y)
{
	float integer_x_int    = floor(x);
	float fractional_x_int = abs(x - integer_x_int);

	float integer_Y    = floor(y);
	float fractional_Y = abs(y - integer_Y);

	float v1 = SmoothNoise(integer_x_int,     integer_Y);
	float v2 = SmoothNoise(integer_x_int + 1.0, integer_Y);
	float v3 = SmoothNoise(integer_x_int,     integer_Y + 1.0);
	float v4 = SmoothNoise(integer_x_int + 1.0, integer_Y + 1.0);

	float i1 = CosineInterp(v1 , v2, fractional_x_int);
	float i2 = CosineInterp(v3 , v4, fractional_x_int);

	return CosineInterp(i1 , i2 , fractional_Y);
}

float perlin(vec2 v)
{
	float total = 0.0;
	const float octaves = 5.0;
	float freq = 2.0;
	float persistence = 0.5;

	for( float i = 0.0; i < octaves; i+=1.0 )
	{
		float frequency = pow(freq, i);
		float amplitude = pow(persistence, i);
		total = total + InterpNoise(v.x * frequency, v.y * frequency) * amplitude;
	}

	return total;
}

void main( void ) {

	vec2 screenPos = gl_FragCoord.xy;
	vec2 screenPosNorm = gl_FragCoord.xy / resolution.xy;
	vec2 position = screenPosNorm + mouse / 4.0;
	vec4 prevColor = texture2D( backbuffer, screenPosNorm );
	
	const float num_iter = 3.0;
	
	float anglebleed = prevColor.x*20.1415 + time*2.0;
	vec2  anglevec = vec2(cos(anglebleed), sin(anglebleed))*2.0 ;
	
	float perlinval = 0.0;
	for ( float i = 0.0; i < num_iter; i++)
	{
		vec2 v = screenPos*0.05*i + anglevec;
		perlinval += perlin( v );
	}
	
	perlinval *= ( 1.0 / float(num_iter) );

	vec3 colorLight = vec3(255.0, 255.0, 169 ) / 255.0;
	vec3 colorDark  = vec3(0.0, 47, 81 ) / 255.0;
	
	float vignette = 1.5-length(screenPosNorm*2.0-1.0);
	
	vec3 curr_color = vec3(mix(colorDark, colorLight, pow( perlinval,5.0) )) * vignette;
	gl_FragColor = vec4( mix(prevColor.xyz, curr_color, 0.05), 1.0 );

}