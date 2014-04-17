// Procedural Tiles // Based on http://www.iquilezles.org/www/articles/smoothvoronoi/smoothvoronoi.htm

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;
varying vec2 surfacePosition;

// Cheap Noise

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rand2(vec2 co){
	float rnd1 = rand(co);
	float rnd2 = rand(co*rnd1);
	return vec2(rnd1,rnd2);
}


// Methods

vec3 tile_color = vec3(0.0);

#define tile_height 0.35
float voronoi( in vec2 x ) {
	vec2 p = floor( x );
	vec2 f = fract( x );
	
	vec3 res = vec3(100.0);
	
	for( int j=-1; j<=1; j++ ) for( int i=-1; i<=1; i++ ) {
		vec2 b = vec2( i, j );
		vec2 r = vec2( b ) + rand( p + b ) - f;
		float d = length(r);
		 
		
		if ( d < res.x ) {
			res.xyz = vec3(d,res.xy);
		} else if (d < res.y) {
			res.yz = vec2(d,res.y);
		}
    	}
	
	return smoothstep(0.0,0.05,res.y-res.x);
}

void main( void ) {

	vec2 p = surfacePosition * 15.0;
	
	float color = voronoi(p);

	gl_FragColor = vec4(vec3(color), 1.0);
}










