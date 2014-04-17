// Procedural Tiles // Based on http://www.iquilezles.org/www/articles/smoothvoronoi/smoothvoronoi.htm
// OP -- added noise + variable tile edge height + more concrete pasty look for in between tiles

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;


// Cheap Noise
float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

vec2 random2f( vec2 seed ) {
	float rnd1 = mod(rand(seed), 1.0);
	float rnd2 = mod(rnd1*2.0,1.0);
	return vec2(rnd1, rnd2);
}

// Methods

float hash(float n) { return fract(pow(sin(n), 1.1)*1e6); }

float noise(vec2 x) {
	vec3 p = vec3(x.xyy);
	const vec3 d = vec3(1.,30.,30.*30.);
	vec3 f = fract(p), p0 = floor(p)*d, p1 = p0 + d;
	f.xy = f.xy * f.xy * (3.0 - 2.0 * f.xy);
	float t = mix(mix(mix(hash(p0.x+p0.y+p0.z), hash(p1.x+p0.y+p0.z),f.x),
		       mix(hash(p0.x+p1.y+p0.z), hash(p1.x+p1.y+p0.z),f.x), f.y),
		   mix(mix(hash(p0.x+p0.y+p1.z), hash(p1.x+p0.y+p1.z),f.x),
		       mix(hash(p0.x+p1.y+p1.z), hash(p1.x+p1.y+p1.z),f.x), f.y), f.z);
	return t*2.-1.;
}

float tile_surface( vec2 p ) {
	float f = 0.0;
	f += 0.3000*noise(p); p *= 1.22;
	f += 0.2500*noise(p); p *= 2.03;
	f += 0.1250*noise(p); p *= 3.01;
	f += 0.0625*noise(p); p *= 4.04;
	return f;
}

vec3 tile_color = vec3(0.0);

#define tile_max_height 0.12
#define tile_min_height 0.05
float voronoi( in vec2 x ) {
	vec2 p = floor( x );
	vec2 f = fract( x );
	
	vec3 res = vec3(1.0);
	
	for( int j=-1; j<=1; j++ ) for( int i=-1; i<=1; i++ ) {
		vec2 b = vec2( i, j );
		vec2 r = vec2( b ) + random2f( p + b ) * 0.7 - f;
		float d = length( r );
		
		if ( d < res.x ) {
			res.xyz = vec3(d,res.xy);
			if (rand(p+b) < 0.5) tile_color = vec3(.77,.87,.9);
			else tile_color = vec3(0.9,0.9,0.9);
		} else if (d < res.y) {
			res.yz = vec2(d,res.y);
		}
    	}
	
	
	
	float h_noise = 0.15*tile_surface((x+dot(tile_color,tile_color))*5.5);
	float h = res.y - res.x - 0.15*sqrt(h_noise);
	
	if (h < tile_min_height) {
		tile_color = vec3(0.12,0.11,0.09);
		return tile_min_height  + sqrt(h_noise);
	}
	
	if (h >= tile_max_height) {
		return tile_max_height - h_noise ;	
	}
	
	return h;
}

vec3 normal(vec2 p) {
	float d = 0.001;
	float d2 = 0.02; // Smoothing parameter for normal
	vec3 dx = vec3(d2, 0.0, voronoi(p + vec2(d2, 0.0))) - vec3(-d, 0.0, voronoi(p + vec2(-d, 0.0)));
	vec3 dy = vec3(0.0, d2, voronoi(p + vec2(0.0, d2))) - vec3(0.0, -d, voronoi(p + vec2(0.0, -d)));
	return normalize(cross(dx,dy));
}

void main( void ) {

	vec2 p = vec2(sin(time),-cos(time)) + (10.*gl_FragCoord.xy)/resolution.y - mouse * vec2(40.0,20.0);
	
	float color = voronoi(p);
	
	float light_intensity = 0.5/tile_max_height;
	vec3 light = normalize(vec3(0.3,0.3,1.0)) * light_intensity;
	
	float shade = dot(light,normal(p))+0.5;
	gl_FragColor = vec4(vec3(shade*color) * tile_color, 1.0);
}










