#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(float f){
    	return fract(sin(dot(vec2(f,0.0) ,vec2(12.9898,78.233))) * 43758.5453);
}

float perlin_bit(float f, float r){
	float x = mod( f, r );
	float s = rand( f - x );
	float e = rand( f + r - x );
	return s + ((e - s) * (x / r));
}

float perlin(float f)
{
	float t = 999999999.0;
	float r = 521312312.0;
	for( int i=0; i<8; ++i )
	{
		t += r * perlin_bit(f,r);
		r *=550.0;
	}
	return t / (1.0 - 2.0 * r);
}
	
void main( void )
{
	float scan = mod( gl_FragCoord.y, 8.0 );
	vec2 position = ( vec2( gl_FragCoord.x, gl_FragCoord.y - scan ) / resolution.xy );
	float noise = perlin((position.y / 0.9) +80.0 * time);
	position.x += 0.01 * sin( noise *102.0 );
	
	float c = 0.5;
	vec3 color = vec3(0.0,0.0,0.0);
	if( position.x >= 0.0 && position.x < 1.0 )
	{
		float angle = time * 0.25;
		vec2 rotated = (position - vec2(0.5,0.5));
		rotated = vec2(
			rotated.x * 1.7 * cos( angle ) - rotated.y * sin( angle ),
			rotated.x * 1.7 * sin( angle ) + rotated.y * cos( angle )
		);
		rotated += vec2(0.5,0.5);
		if( (mod( rotated.x, 0.2 ) > 0.1) ^^ (mod( rotated.y, 0.2 ) > 0.1) )
		{
			c = 1.0;
		}
		color = vec3( c, c * 0.5, sin( c + time / 3.0 ) * 0.75 );
	}
	//color = vec3( noise, noise, noise );
	
	gl_FragColor = vec4( color * ((scan > 4.0) ? 0.8 : 1.0), 1.0 );
}