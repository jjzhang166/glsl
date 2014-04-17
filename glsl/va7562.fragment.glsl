#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse, resolution;

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

float voronoi( in vec2 x ) {
	vec2 p = floor( x );
	vec2 f = fract( x );
	float rv = 1.0;

	for( int j=-1; j<=1; j++ ) for( int i=-1; i<=1; i++ ) {
		vec2 b = vec2( i, j );
		vec2 r = vec2( b ) + rand2( p + b ) - f;
		float d = dot( r , r );
		if ( d < rv ) {
		  rv = d;
		}		
    	}
	return rv;
}

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution;
	vec2 p = vec2(sin(time / 5.0),-cos(time / 5.0)) + uv / 0.1;
	
  float color = voronoi(p);

  color = cos(color);

	
	gl_FragColor = vec4(color);
	
}

