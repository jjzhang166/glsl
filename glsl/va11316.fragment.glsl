#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;



float hash( float n )
{
	return fract( sin( n ) * 43758.5453 );
}

float noise3( in vec3 x )
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

#define PI 3.14159
#define TWO_PI (PI*2.0)


float fbm( in vec2 point, in float alpha )
{
	vec2 p = point;
	float f = 0.0;
	
	mat2 m = mat2( cos(alpha), sin(alpha), -sin(alpha), cos(alpha) );
	
	//amplitude * noise3( frequency )
	f += 1.0000 * noise3( vec3( p, 1.0 ) ); p *= m * 25.02; // octaves...
	f += 0.5000 * noise3( vec3( p.yx, 1.0 ) ); p *= m * 10.02; // octaves...
	f += 0.2500 * noise3( vec3( p, 1.0 ) ); p *= m * 5.03;
	f += 0.1250 * noise3( vec3( p.yx, 1.0 ) ); p *= m * 2.01;
	f += 0.0625 * noise3( vec3( p, 1.0 ) );
	f /= 2.4375;
	
	return f;
}

#define N 30.0

void main( void ) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 5.0;

	float col = 0.0;
	float t = time * 0.5;
	for(float i = 0.0; i < N; i++) {
	  	float a = t*0.01+atan(pow(sin(t*0.01),3.0))*cos(t*0.001)*10.0+50.0;
		float b = t*0.02+tan(pow(cos(t*0.01),2.0))*atan(t*0.01)*10.0+50.0;
		mat2 m = mat2( cos(b), sin(a), -sin(b+a), cos(b) );
		col += cos( 1.2*TWO_PI*(v.x * cos(a*i*1.1) + v.y *tan(a*i*1.0)*cos(a*i*1.0)))*max(sin(i*b),-0.5) * fbm(v*m, b)*1.1;
	}
	
	col *= 0.7;

	vec4 cfore = vec4(0.1+col*(0.5+sin(t)*0.3)) * vec4(col) * 1.5;
	vec4 dbuff = texture2D(backbuffer,0.5+col*cos(v*0.7)*1.1) * 0.1;
	
	gl_FragColor = cfore + dbuff;
}

