#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 packDepth( float depth )
{
	vec2 outVec;

	float encode_value = depth * 255.0;
	outVec.x = floor( encode_value );
	encode_value = fract( encode_value );
	outVec.y = floor( encode_value * 255.0 );
	
	return outVec;
}

float unpackDepth( vec2 packed_depth )
{
	float decode_value = packed_depth.y / 255.0;
	decode_value = ( packed_depth.x + decode_value ) / 255.0;
	return decode_value;
}

void main( void )
{
	gl_FragColor = vec4( 1.0 );

}