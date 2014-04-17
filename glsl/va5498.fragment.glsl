#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Visualization of the voronoi field in 3D. red = center of cell, blue = edge between cells. Loosely based on the work of others (hit "parent" to see more). - Kabuto

vec3 random3f( vec3 seed ) {
	vec3 r = fract(seed*mat3(0.6299523843917996,0.18076110584661365,0.7744768380653113,0.07479058369062841,0.6860866188071668,0.7200816590338945,0.38891187869012356,0.9161028724629432,0.5484214460011572));
	return fract(r+r.yzx*r.zxy*4190.2654);
}

vec3 voronoi( in vec3 x ){
    vec3 p = floor( x );
    vec3 f = fract( x );

    float res = 8.0;
    float res2 = 8.0;
    float res3 = 8.0;
	
    for( int k=-1; k<=1; k++ )
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec3 b = vec3( i, j, k );
        vec3 r = b - f + random3f( p + b );
        float d = dot( r, r );

    if (d < res) {res3 = res2; res2 = res; res = d; } else if (d < res2) {res3 = res2; res2 = d;} else if (d < res3) res3 = d;
     }
	return vec3(sqrt(res),sqrt(res2),sqrt(res3));
}

void main( void ) {

	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));
	vec3 pos = vec3(mouse-.5,time);
	
	vec3 color = vec3(0.);
	for (int i = 0; i < 30; i++) {
		vec3 d3= voronoi(pos);
		float d = min(d3.x,(d3.z-d3.x)*.5);
		pos += dir*d;
		color += 1./(vec3(d3.x,90/*d3.y-d3.x+.05*/,d3.z-d3.x)+.0001);
	}
	
	color = 1.-1./(1.+color*vec3(.02,.006, .01));
	color = (color-.2)*1.25;
	color *= color;
	
	//color *= 20.;

	gl_FragColor = vec4( color, 1.0 );

}