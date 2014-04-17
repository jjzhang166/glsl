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

float track(int n,float t)
{
	if(n==1)
		return t<5.0? 1.0:
			t<10.0? 2.0:
			10.0*(sin(t*3.)>.9?10.0:.1)
				*(sin(t*5.)<-.9?10.0:1.0)
				*(sin(t*7.)<-.8?-3.0:1.0)
			;
	return 1.;
}

float sinwave(vec2 point,float t)
{
	return sin(point.x*10.0+t* 10.);
}

float altern(float x)
{
	return sin(x*10.);//>0.?-1.:1.;
}
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 uv = position;
	position-=.5;
	float t = time*.5;
	float color = 0.0;

	
	color =sinwave(position*10.*(atan(.1/uv.y)),t);
	gl_FragColor = vec4( vec3( color, altern(t*track(1,t))*color*sin(uv.y*100.), altern(t)*color*sin(t+position.x*10.*(1.-uv.y)) ),1.0);
}