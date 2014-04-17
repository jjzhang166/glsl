
// This is a cross-breed; voronoi dna jumped over into this world, but poorly integrated... help?! :) 
// Get the voronoi texture from the ray coords, not the screen coords and it's projected automatically :) (psonice)
// Thanks psonice. I *4'd it to see more pattern... --@danbri

/* Following iQ live coding tutorial on writing a basic raytracer http://www.youtube.com/watch?v=9g8CdctxmeU   @blurspline 
  * ... this forked version mostly just scrunched up to fit in less space without obfuscating too much. @danbri */

//forked and added cloud shadows
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse, resolution;


const vec2 wind = vec2(0.0006,0.0004314);
const float cloudSize = 0.000314; //smaller is bigger
const float fogginess = 0.1; //smaller is bigger
const float softness  = 0.5; 
vec4 textureRND2D2(vec2 uv){
	uv = floor(fract(uv)*1e3);
	float v = uv.x+uv.y*1e3;
	return fract(1e5*sin(vec4(v*1e-2, (v+1.)*1e-2, (v+1e3)*1e-2, (v+1e3+1.)*1e-2)));
}

float noise22(vec2 p) {
	vec2 f = fract(p*1e3);
	vec4 r = textureRND2D2(p);
	f = f*f*(3.0-2.0*f);
	return (mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y));	
}

float shadow(vec2 surface)
{
	vec2 p = surface * cloudSize + 0.5 + time * wind;
	float c0 = noise22(p * .1760312  +time*.00007535);
	float c1 = noise22(p * .219811132 -time*.0000852528917);
	
	float cf = 1.0 - smoothstep(fogginess, fogginess+softness, c0*c1);
	
	return cf;
}
mat2 m = mat2( 0.90,  0.110, -0.70,  1.00 );

float hash( float n )
{
    return fract(sin(n)*758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    //f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + p.z*800.0;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
		    mix(mix( hash(n+800.0), hash(n+801.0),f.x), mix( hash(n+857.0), hash(n+858.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = p*2.02;
    f += 0.25000*noise( p ); p = p*2.03;
    f += 0.12500*noise( p ); p = p*2.01;
    f += 0.06250*noise( p ); p = p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float cloud(vec3 p)
{
	p+=fbm(vec3(p.x,p.y,0.0)*0.5)*2.25;
	
	float a =0.0;
	a+=fbm(p*3.0)*2.2-0.9;
	if (a<0.0) a=0.0;
	//a=a*a;
	return a;
}

vec3 f2(vec3 c)
{
	c+=hash(time+gl_FragCoord.x+gl_FragCoord.y*9.9)*0.01;
	
	
	c*=0.7-length(gl_FragCoord.xy / resolution.xy -0.5)*0.7;
	float w=length(c);
	c=mix(c*vec3(1.0,1.2,1.6),vec3(w,w,w)*vec3(1.4,1.2,1.0),w*1.1-0.2);
	return c;
}
	
	
	
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
			if (rand(p+b) < 0.5) tile_color = vec3(.77,.87,1.1);
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
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	float q = cloud(vec3(position,time*0.15));
	vec3 skycol =vec3(0.35,0.4,0.7) + vec3(q*vec3(0.8,0.8,0.8));
	
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
        vec3 col = skycol;
	float id = intersect( ro, rd, t ); 		// we intersect ray with 3d scene
	//vec3 col = vec3(0.65);
	if ( id>0.5 && id<1.5 ) {			// sphere		
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp( dot( nor, light ), 0.0, 1.0); // diffuse light
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3( 0.8, 0.8, 0.6) * dif * shadow(pos.xy)*ao + vec3(0.1, 0.1, 0.3) * ao;
	} else if ( id>1.5 ) {				// plane
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane( pos );
		float dif = clamp( dot(nor, light), 0.0, 1.0 );
		float amb = smoothstep( 0.0, sph1.w * 2.0, length(pos.xz - sph1.xz) ); // shadows under the sphere
		col = vec3 (amb * 0.9);

		
		// voronoi texture is here but needs projecting properly into the angled plane:
		vec2 p = pos.xz * 4.  +vec2(sin(time/10.), cos(time/10.));
		float color = voronoi(p);
		vec3 vnorm = normal(p);
		float shade = 1.5*shadow(p)*dot(light,vnorm)+0.085;
		col.rgb *= vec4(vec3(color*shade) * tile_color, 1.0).rgb;
		
	}		
	gl_FragColor = vec4( sqrt(col), 1.0 );
}