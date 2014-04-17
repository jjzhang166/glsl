#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 random2f( vec2 seed ) {
	float t = sin(seed.x+seed.y*1e3);
	return vec2(fract(t*1e4), fract(t));
}

float cvoronoi( in vec2 x )
{
    vec2 p = floor( x );
    vec2  f = fract( x );

    float res = 1.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2( i, j );
        vec2 r = vec2( b ) - f + random2f( p + b );
        float d = dot( r, r );
	res = min(res, fract(d*7.0-time + x.x*0.3));
    }	
    return pow(res, 0.4);
}



void main( void )
{
	vec2 p = gl_FragCoord.xy / resolution.xy;
	
	p*=7.0;
	gl_FragColor = vec4(vec3(cvoronoi(p)),1.0);
}