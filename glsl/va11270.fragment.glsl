#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash( float n )
{
	return fract( sin( n ) * 43758.5453 );
}

float noise( in vec3 x )
{
	vec3 p = floor( x );
	vec3 q = fract( x );
	q = q * q * (3.0 - 2.0 * q);
	
	float n = p.x + p.y * 57.0 + p.z * 113.0;
	
	float a = hash( n );
	float b = hash( n + 1.0 );	
	float c = hash( n + 57.0 );
	float d = hash( n + 58.0 );

	float e = hash( n + 113.0 );	
	float f = hash( n + 114.0 );
	float g = hash( n + 170.0 );
	float h = hash( n + 171.0 );	
	
	float result = mix( mix( mix( a, b, q.x ), mix( c, d, q.x ), q.y ),
			    mix( mix( e, f, q.x ), mix( g, h, q.x ), q.y ),
			   q.z );
	
	return result;
}

// rotation matrix, propotional to a right triangle, rotates octaves ~36°
const mat2 m = mat2( 0.8, 0.6, -0.6, 0.8 );

float fbm( in vec2 point )
{
	vec2 p = point;
	float f = 0.0;
	
	//amplitude * noise( frequency )
	f += 0.5000 * noise( vec3( p, 1.0 ) ); p *= m * 2.02; // octaves...
	f += 0.2500 * noise( vec3( p, 1.0 ) ); p *= m * 2.03;
	f += 0.1250 * noise( vec3( p, 1.0 ) ); p *= m * 2.01;
	f += 0.0625 * noise( vec3( p, 1.0 ) );
	f /= 0.9375;
	
	return f;
}

void main( void ) 
{
	float aspectRatio = resolution.x / resolution.y;
	vec2 p = (gl_FragCoord.xy / resolution * 2.0 - 1.0);
	p.x *= aspectRatio;	// p.x... [-aspectRatio, +aspectRatio], p.y... [-1, +1], top left is (-aspectRatio, +1)

	//float f = fbm( 4.0 * p ); // nice noise texture
	//vec3 color = vec3( f );

	vec3 background = vec3( 0.0, 0.0, 0.1 );
	vec3 color = background;
	
	float radius = sqrt( dot( p, p ) );
	float angle = atan( p.y, p.x );
	
	
	float animation = 1.0 + 0.01 * sin( time * 3.0 );
	radius *= animation;
	
	if( radius < 0.8 )
	{
		color = vec3( 0.8, 0.1, 0.1);
		float f = fbm( 6.0 * p );
		color = mix( color, vec3( 0.8, 0.9, 0.1 ), f );
		
		f = 1.0 - smoothstep( 0.2, 0.5, radius );
		color = mix( color, vec3( 0.1, 0.9, 0.1 ), f );
		
		angle += 0.08 * fbm( 8.0 * p );
		
		f = smoothstep( 0.4, 1.0, fbm( vec2( 6.0 * radius, 20.0 * angle ) ) );
		color = mix( color, vec3( 1.0, 1.0, 1.0 ), f );

		f = smoothstep( 0.4, 0.9, fbm( vec2( 10.0 * radius, 15.0 * angle ) ) );
		color *= 1.0 - f * 0.4;
		
		f = smoothstep( 0.6, 0.8, radius );
		color *= 1.0 - f;

		f = smoothstep( 0.2, 0.25, radius );
		color *= f;
		
		f = 1.0 - smoothstep( 0.0, 0.35, length( p - vec2( 0.3, 0.3) ) );
		color += vec3( f ) * 0.9;
		
		f = smoothstep( 0.7, 0.8, radius );
		color = mix( color, background, f );
	}
	

	
	gl_FragColor = vec4( color, 1.0 );

}