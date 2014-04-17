// Some code borrowed from IQ's awesome site:
// http://www.iquilezles.org/www/articles/smoothvoronoi/smoothvoronoi.htm
// http://www.iquilezles.org/www/articles/voronoilines/voronoilines.htm

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec2 random2f( vec2 seed )
{
	float rnd1 = mod(fract(sin(dot(seed, vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd2 = mod(fract(sin(dot(seed+vec2(rnd1), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	return vec2(rnd1, rnd2);
}

float voronoiDistance( in vec2 x )
{
    vec2 p = floor( x );
    vec2 f = fract( x );

    vec2 mb;
    vec2 mr;

    float res = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2( i, j );
        vec2 r = vec2( b ) + random2f( p + b ) - f;
        float d = dot(r,r);

        if( d < res )
        {
            res = d;
            mr = r;
            mb = b;
        }
    }

    res = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2( i, j );
        vec2 r = vec2( mb + b ) + random2f( p + mb + b ) - f;
        float d = dot( 0.5*(mr+r), normalize(r-mr) );

        res = min( res, d );
    }

    return res;
}

float getBorder( in vec2 p )
{
    float dis = voronoiDistance( p );

    return 1.0 - smoothstep( 0.0, 0.05, dis );
}

void main( void ) {

	vec2 position = surfacePosition * 10.0 + mouse * 2.0;

	float color = getBorder(position);

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}