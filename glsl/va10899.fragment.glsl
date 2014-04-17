#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(float f){
    	return fract(sin(dot(vec2(f,0.0) ,vec2(42.9898,78.233))) * 43758.5453);
}

float perlin_bit(float f, float r){
	float x = mod( f, r );
	float s = rand( f - x );
	float e = rand( f + r - x );
	return s + ((e - s) * (x / r));
}

float perlin(float f)
{
	float t = 0.0;
	float r = 0.5;
	for( int i=0; i<16; ++i )
	{
		t += r * perlin_bit(f,r);
		r *= 0.5;
	}
	return t;
}
	
void main( void )
{
	float scan = mod( gl_FragCoord.y, 4.0 );
	vec2 position = ( vec2( gl_FragCoord.x, gl_FragCoord.y - scan ) / resolution.xy );
	float noise = perlin((position.y / 0.1) + time);
	position.x += 0.01 * sin( noise * 6.283 );
	
	float c = 0.0;
	c += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	c += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	c += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	c *= sin( time / 10.0 ) * 0.5;
	vec3 color = vec3( c, c * 0.5, sin( c + time / 3.0 ) * 0.75 );
	
	gl_FragColor = vec4( color * ((scan > 2.0) ? 0.8 : 1.0), 1.0 );
}