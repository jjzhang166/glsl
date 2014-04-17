
// This is a cross-breed; voronoi dna jumped over into this world, but poorly integrated... help?! :) 
// Get the voronoi texture from the ray coords, not the screen coords and it's projected automatically :) (psonice)
// Thanks psonice. I *4'd it to see more pattern... --@danbri

/* Following iQ live coding tutorial on writing a basic raytracer http://www.youtube.com/watch?v=9g8CdctxmeU   @blurspline 
  * ... this forked version mostly just scrunched up to fit in less space without obfuscating too much. @danbri */
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse, resolution;
vec3 nSphere( in vec3 pos, in vec4 sph ) { return ( pos - sph.xyz ) / sph.w; }  // normals(?)
vec3 nPlane( in vec3 pos ) {	return vec3 (0.0, 1.0, 0.0); }
vec4 sph1 = vec4( 0.0, 1.0, 0.0, 1.0); // sphere, w is size
float iPlane( in vec3 ro, in vec3 rd ) { return -ro.y / rd.y; } // intersections
float iSphere( in vec3 ro, in vec3 rd, in vec4 sph ) {
	vec3 oc = ro - sph.xyz; // looks like we are going place sphere from an offset from ray origin, which is = camera
	float b = 2.0 * dot( oc, rd );
	float c = dot(oc, oc) - sph.w * sph.w; // w should be size
	float h = b*b - 4.0 *c;
	if (h<0.0) { return -1.0; }
	float t = (-b - sqrt(h)) / 2.0;
	return t;
}
float intersect( in vec3 ro, in vec3 rd, out float resT ) {
	resT = 1000.;
	float id = -1.0;
	float tmin = -1.0;
	float tsph = iSphere( ro, rd, sph1 ); 
	float tpla = iPlane( ro, rd ); 
	if ( tsph>0.0 ) {
		resT = tsph;
		id = 1.0;
	}
	if (tpla > 0.0 && tpla <resT ) {
		id = 2.0;
		resT = tpla;
	}	
	return id;
}




vec4 textureRND2D(vec2 uv){
	uv = floor(fract(uv)*1e3);
	float v = uv.x+uv.y*1e3;
	return fract(1e5*sin(vec4(v*1e-2, (v+200.)*1e-2, (v+1e3)*1e-2, (v+1e3+1.)*1e-2)));
}

float noise(vec2 p) {
	vec2 f = fract(p*1e3);
	vec4 r = textureRND2D(p);
	f = f*f*(3.0-2.0*f);
	return (mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y));	
}

vec2 random2f( vec2 seed ) {
	#define rnd_seed 1.337
	float rnd1 = mod(noise(seed*rnd_seed), 1.0);
	float rnd2 = mod(rnd1*2.0,1.0);
	
	return vec2(rnd1, rnd2);
}

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
	
	vec3 res = vec3(1.0);
	
	for( int j=-1; j<=1; j++ ) for( int i=-1; i<=1; i++ ) {
		vec2 b = vec2( i, j );
		//vec2 r = vec2( b ) + rand2( p + b ) - f; // cheap
		vec2 r = vec2( b ) + random2f( p + b ) - f; // expensive but has some nicer properties for morphing
		float d = dot( r , r );
		
		if ( d < res.x ) {
			res.xyz = vec3(d,res.xy);
			if (rand(p+b) < 0.5) tile_color = vec3(.77,.87,.9);
			else tile_color = vec3(0.9,0.9,0.9);
		} else if (d < res.y) {
			res.yz = vec2(d,res.y);
		}
    	}
	
	return clamp(sqrt(res.y) - sqrt(res.x),0.0,tile_height);
}

vec3 normal(vec2 p) {
	float d = 0.001;
	float d2 = 0.01; // Smoothing parameter for normal
	vec3 dx = vec3(d2, 0.0, voronoi(p + vec2(d2, 0.0))) - vec3(-d, 0.0, voronoi(p + vec2(-d, 0.0)));
	vec3 dy = vec3(0.0, d2, voronoi(p + vec2(0.0, d2))) - vec3(0.0, -d, voronoi(p + vec2(0.0, -d)));
	return normalize(cross(dx,dy));
}



void main( void ) {

	// from main2
	vec2 p = vec2(sin(time),-cos(time)) + (3.*gl_FragCoord.xy)/resolution.y - mouse * vec2(40.0,20.0); 
	//float color = voronoi(p);	
	float light_intensity = 0.75/tile_height;
	vec3 light = normalize(vec3(1.0,0.1,1.0)) * light_intensity;
	float shade = dot(light,normal(p))+0.5;
	//gl_FragColor = vec4(vec3(shade*color) * tile_color, 1.0);
	
	
	// vec3 light = normalize( vec3(0.5,0.6,0.4) );	// ok, here we come, GLSL raytacing!
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );  // this is the pixel coords
	sph1.xz = vec2 ( 0.5 * cos( time ),  0.5 * sin( time )); // move sphere around	
	vec3 ro = vec3( -3.1, 0.4, 4.0 ); //ray origin
	vec3 rd = normalize( vec3( -1.0 + 2.*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) ); // ray destination
	float t;
        vec3 col = vec3(.3);
	float id = intersect( ro, rd, t ); 		// we intersect ray with 3d scene
	//vec3 col = vec3(0.65);
	if ( id>0.5 && id<1.5 ) {			// sphere		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.0, 1.0); // diffuse light
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3( 0.8, 0.8, 0.6) * dif * ao + vec3(0.1, 0.2, 0.4) * ao;
	} else if ( id>1.5 ) {				// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		col = vec3 (amb * 0.9);

		
		// voronoi texture is here but needs projecting properly into the angled plane:
		float color = voronoi(pos.xz * 4.);
		col.rgb *= vec4(vec3(color) * tile_color, 1.0).rgb;
	}		
	gl_FragColor = vec4( sqrt(col), 1.0 );
}