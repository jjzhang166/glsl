#ifdef GL_ES
precision mediump float;
#endif

// weighted companion mandelbox
// @acaudwell

// heart from shader toy:
// http://www.iquilezles.org/apps/shadertoy/?p=heart

// mandelbox:
// http://www.fractalforums.com/3d-fractal-generation/a-mandelbox-distance-estimate-formula/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray {
    vec3 origin;
    vec3 dir;
};

struct Block {
    vec3 pos;
    vec3 dims;
    vec3 min;
    vec3 max;
    vec3 colour;
};

float fov    = tan(55.0 * 0.017453292 * 0.5);
float aspect = resolution.x / resolution.y;

float heart(vec2 p) {

    float a = atan(p.x,p.y)/3.141593;
    float r = length(p*vec2(1.0, 1.0));

    // shape
    float h = abs(a);
    float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

    return min(1.0,1.0-pow(1.0-r/d,0.25));
}

Ray initRay(vec3 origin, vec2 pos) {

    Ray ray;
    ray.origin = origin;
    ray.dir    = normalize(vec3(pos.x * fov * aspect, pos.y * fov, 1.0));
    return ray;
}
	
Block initBlock(vec3 pos, vec3 dims, vec3 colour, vec3 axis, float angle) {

    Block block;
    block.pos    = pos;
    block.dims   = dims;
    block.colour = colour;	
    block.min    = pos - dims* 0.5;
    block.max    = pos + dims* 0.5;
    return block;
}
	
// look ma, no ray marching!

bool rayBlockIntersect(const Ray ray, Block block, out float near, out float far, out Block match) {

    vec3 t1 = (block.min - ray.origin) / ray.dir;
    vec3 t2 = (block.max - ray.origin) / ray.dir;

    near = max( max( min(t1.x, t2.x), min(t1.y, t2.y)), min(t1.z, t2.z) );
    far  = min( min( max(t1.x, t2.x), max(t1.y, t2.y)), max(t1.z, t2.z) );

    match = block;
	
    return near < far && far >= 0.0;
}

#define MAX_ITERATIONS 6

float texture(vec3 p, float box_fold, float min_radius_2, float scale) {

    vec4 c = vec4(p, float(1.0));
    vec4 w = c;
    vec3 v = w.xyz;

    vec4 scale_factor = vec4(scale, scale, scale, abs(scale)) / min_radius_2;

    for (int i = 0; i < MAX_ITERATIONS; i++) {
        v = clamp(v, -box_fold, box_fold) * float(2.0) * box_fold - v;
        w = vec4(v, w.w) * clamp(max(min_radius_2 / dot(v, v), min_radius_2), float(0.0), float(1.0));
        w = w * scale_factor + c;
        v = w.xyz;
    }

    return (length(v) - abs(scale) - float(1.0)) / w.w - pow(abs(scale), float(1-MAX_ITERATIONS));
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;

        Ray ray = initRay(vec3(0.0, 0.0, 1.5), position+(mouse-0.5)*0.25);        	

	//heart cube
	Block hc = initBlock(vec3(-0.2, -0.25, 2.3), vec3(0.25), vec3(0.97, 0.5, 0.67), vec3(1.0), 0.0);

	//generic cubes
	Block gc1 = initBlock(vec3(0.25, -0.25, 2.5), vec3(0.25), vec3(0.97, 0.5, 0.67), vec3(1.0), 0.0);
	Block gc2 = initBlock(vec3(0.8, -0.25, 2.7), vec3(0.25), vec3(0.97, 0.5, 0.67), vec3(1.0), 0.0);
	Block gc3 = initBlock(vec3(-0.9, -0.25, 2.75), vec3(0.25), vec3(0.97, 0.5, 0.67), vec3(1.0), 0.0);
	
	//floor
	Block fl = initBlock(vec3(0.0, -0.375, 2.5),   vec3(4.0, 0.001, 5.0), vec3(0.67), vec3(1.0), 0.0);
	
	vec4 c = vec4(vec3(0.0), 1.0);
	
	float near, far;
	
	Block match;
	
	//heart cube
	if(rayBlockIntersect(ray, hc, near, far, match)) {
		vec3 p = ray.origin + ray.dir *(near+0.0001);
			
   	        vec3 tx = (((p - hc.min) / hc.dims) - 0.5) * 1.05;
		
		// mandelbox texture
		float t2 = min(1.0, min(1.0, texture(tx*0.93, 1.1, 1.0, 3.0)* pow(1.9, 6.5)) * (1.0-pow(near / 1.5, 1.0)));		

    	        float t1 = 1.0-texture(tx*0.67, 2.0, 0.25, 4.0)*0.75;
		float circle = min(1.0, min(1.0, texture(tx, 1.0, 0.35, 2.5)* pow(1.6, 6.5)) * (1.0-pow(near / 1.3, 1.7)));		
		float circle2 = min(1.0, min(1.0, texture(tx*1.3, 1.0, 0.35, 2.5)* pow(1.6, 6.5)));		

		// heart
		float h = heart(tx.xy*4.0-vec2(0.0, 0.25));
		
		c.xyz = hc.colour * max((1.0-t1*0.8-max(t2,circle)+circle2*0.5),1.0-h)*2.0;	
	}
	else if(   rayBlockIntersect(ray, gc1, near, far, match)
		|| rayBlockIntersect(ray, gc2, near, far, match)
		|| rayBlockIntersect(ray, gc3, near, far, match)) {
		
		vec3 p = ray.origin + ray.dir *(near+0.0001);
			
   	        vec3 tx = (((p - match.min) / match.dims) - 0.5) * 1.05;
		
		// mandelbox texture
		float t1 = 1.0-texture(tx*0.67, 2.0, 0.25, 4.0)*0.5;
		float t3 = min(1.0, min(1.0, texture(tx*0.93, 1.1, 1.0, 3.0)* pow(1.9, 6.5)) * (pow(near / 2.35, 1.7)));		
		float circle1 = min(1.0, min(1.0, texture(tx, 1.0, 0.35, 2.5)* pow(1.6, 6.5)));		
		float circle2 = min(1.0, min(1.0, texture(tx*1.3, 1.0, 0.35, 2.5)* pow(1.6, 6.5)));		
				
		c.xyz = vec3(1.0-t1*0.8-t3-circle1*0.2+circle2*0.5);
		
	} else if(rayBlockIntersect(ray, fl, near, far, match)) {
		vec3 p = ray.origin + ray.dir *(near+0.0001);
   	        
		vec3 tx = ((p - fl.min) / fl.dims) - 0.5;
		c.xyz = fl.colour * min(1.0, texture(tx, 1.0, 0.3, 3.5) * pow(1.3, 11.0) * (1.0-pow(near / 2.0, 0.5)))*0.5;

		Ray shadow;
		shadow.origin = p;
		shadow.dir    = normalize(ray.origin-p+vec3(0.05, 0.05, 0.0));
		
		if(  rayBlockIntersect(shadow, hc, near, far, match)
		   || rayBlockIntersect(shadow, gc1, near, far, match)
		   || rayBlockIntersect(shadow, gc2, near, far, match)
		   || rayBlockIntersect(shadow, gc3, near, far, match)) {
			c.xyz *= 0.5;
		}

	}
	
	gl_FragColor = vec4( c );

}