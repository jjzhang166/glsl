// Some code borrowed from IQ's awesome site:
// http://www.iquilezles.org/www/articles/smoothvoronoi/smoothvoronoi.htm

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

float voronoi( in vec2 x )
{
    vec2 p = floor( x );
    vec2 f = fract( x );

    float res = 8.0;
    float res2 = 8.0;
    float res3 = 8.0;
	
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2( i, j );
        vec2 r = vec2( b ) - f + random2f( p + b );
        float d = dot( r, r );

	if (d < res) {
		res3 = res2; res2 = res; res = d;
	} else if (d < res2) {
		res3 = res2; res2 = d;
	} else if (d < res3)
		res3 = d;
     }
    return 0.2+sqrt(res2)-sqrt( res );
}

void main( void ) {

	vec2 position = surfacePosition * 10.0 + mouse * 2.0;

	float color = voronoi(position);

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}