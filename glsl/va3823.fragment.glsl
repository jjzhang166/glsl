#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

const float toFixed = 255.0/256.0;
const float fromFixed = 256.0/255.0;

const float maxRange = 255.0;
	
/*vec4 EncodeFloatRGBA( float floatVal ) {
	
	floatVal = floatVal / maxRange;
	
	return vec4(
		fract(floatVal*toFixed*1.0),
		fract(floatVal*toFixed*255.0),
		fract(floatVal*toFixed*65025.0),
		fract(floatVal*toFixed*16581375.0)
	);

}

float DecodeFloatRGBA( vec4 rgbaVal ) {
	
	return (rgbaVal.r*fromFixed/1.0)
		+ (rgbaVal.g*fromFixed/255.0) 
		+ (rgbaVal.b*fromFixed/65025.0)
		+ (rgbaVal.a*fromFixed/16581375.0)
		  * maxRange;

}*/

// Packing a [0-1] float value into a 4D vector where each component will be a 8-bits integer
vec4 packFloatToVec4i(float value)
{
   const vec4 bitSh = vec4(256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0);
   const vec4 bitMsk = vec4(0.0, 1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0);
   vec4 res = fract(value * bitSh);
   res -= res.xxyz * bitMsk;
   return res;
}
 
// Unpacking a [0-1] float value from a 4D vector where each component was a 8-bits integer
float unpackFloatFromVec4i(vec4 value)
{
   const vec4 bitSh = vec4(1.0 / (256.0 * 256.0 * 256.0), 1.0 / (256.0 * 256.0), 1.0 / 256.0, 1.0);
   return(dot(value, bitSh));
}

void main( void ) {

	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	
	float initVal = gl_FragCoord.x * 1.0;
	
	vec4 encTest = packFloatToVec4i( initVal / maxRange );
	
	float decTest = unpackFloatFromVec4i( encTest ) * maxRange;
	
	if( decTest == initVal ) {
		color = vec4(1.0, 1.0, 1.0, 1.0);
	}
	
	gl_FragColor = color;

}