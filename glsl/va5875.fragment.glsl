#ifdef GL_ES
precision mediump float;
#endif

// http://www.iquilezles.org/www/articles/smoothvoronoi/smoothvoronoi.htm

varying vec2 surfacePosition;
uniform float time;

vec2 random2f( vec2 seed ) {
	float t = sin(seed.x+seed.y*1e3);
	return vec2(fract(t*1e5), fract(t*1e6));
}

float voronoi( in vec2 x )
{
    vec2 p = floor( x );
    vec2  f = fract( x );

    float res = 0.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2( i, j );
        vec2  r = vec2( b ) - f + random2f( p + b );
        float d = dot( r, r );

        res += 1.0/pow( d, 8.0 );
    }
    return pow( 1.0/res, 1.0/16.0 );
}

vec3 clover( float x, float y )
{
    float a = atan(x,y);
    float r = sqrt(x*x+y*y);
    float s = 0.5 + 0.5*sin(3.0*a);
    float g = sin(1.57+3.0*a);
    float d = 0.3 + 0.6*sqrt(s) + 0.15*g*g;
    float h = r/d;
    float f = 1.0-smoothstep( 0.95, 1.0, h );
    h *= 1.0-0.5*(1.0-h)*smoothstep(0.95+0.05*h,1.0,sin(3.0*a));
    return mix( vec3(0.0), vec3(0.5*h,0.2+0.2*h,0.0), f );
}

void main( void )
{
	vec2 p = surfacePosition*2.;
	float a = time*.1;
	p = vec2(p.x*cos(a)-p.y*sin(a), p.y*cos(a)+p.x*sin(a));
	gl_FragColor = vec4(clover(p.x, p.y) * (voronoi(p*80.)+.5), 1.0);
}