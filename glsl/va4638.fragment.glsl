// voxels!
// @simesgreen

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

// CSG operations
vec2 _union(vec2 a, vec2 b)
{
    //return min(a, b);
    return (a.x < b.x) ? a : b;
}

float intersect(float a, float b)
{
    return max(a, b);
}

float diff(float a, float b)
{
    return max(a, -b);
}

// primitive functions
// these all return the distance to the surface from a given point

float plane(vec3 p, vec3 planeN, vec3 planePos)
{
    return dot(p - planePos, planeN);
}

float box( vec3 p, vec3 b )
{
  vec3 d = abs(p) - b;
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}

float sphere(vec3 p, float r)
{
    return length(p) - r;
}

// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

float sdCone( vec3 p, vec2 c )
{
    // c must be normalized
    float q = length(p.xz);
    return dot(c, vec2(q, p.y));
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

// transforms
vec3 rotateX(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = p.x;
    r.y = ca*p.y - sa*p.z;
    r.z = sa*p.y + ca*p.z;
    return r;
}

vec3 rotateY(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = ca*p.x + sa*p.z;
    r.y = p.y;
    r.z = -sa*p.x + ca*p.z;
    return r;
}

// distance to scene
// returns (nearest distance, material id)
vec2 scene(vec3 p)
{	
    vec2 d;	
    d.x = sphere(p, 1.0);
    d.y = 0.0; // id
    d = _union(d, vec2(sphere(p - vec3(-0.0, -0.4, 1.8), 0.6), 1.0));	
    //d = _union(d, vec2(sdTorus(p - vec3(2.0, -0.5, 1.0), vec2(1.0, 0.35)), 1.0));
    //d = _union(d, vec2(box(p - vec3(-0.0, 0.0, 2.0), vec3(1.0)), 1.0));
    d = _union(d, vec2(plane(p, vec3(0.0, 1.0, 0.0), vec3(0.0, -1.0, 0.0)), 3.0));
    return d;
}

vec3 matToColor(float id)
{
    if (id == 0.0) {
        return vec3(1.0, 0.0, 0.0);
    } else if (id == 1.0) {
	return vec3(0.0, 1.0, 0.0);
    } else {
	return vec3(0.5, 0.5, 0.5);
    }	
}


// Amanatides & Woo style voxel traversal
const vec3 voxelSize = vec3(0.1); // in world space
//const vec3 voxelSize = vec3(0.2);

vec3 worldToVoxel(vec3 i)
{
    return floor(i/voxelSize);
}

vec3 voxelToWorld(vec3 i)
{
    return i*voxelSize;	
}

vec3 voxelTrace(vec3 ro, vec3 rd, out bool hit, out vec3 hitNormal, out vec3 hitColor)
{
    const int maxSteps = 64;
    const float isoValue = 0.0;

    vec3 voxel = worldToVoxel(ro);
    vec3 step = sign(rd);

    vec3 nearestVoxel = voxel + vec3(rd.x > 0.0, rd.y > 0.0, rd.z > 0.0);
    vec3 tMax = (voxelToWorld(nearestVoxel) - ro) / rd;
    vec3 tDelta = voxelSize / abs(rd);

    vec3 hitVoxel = voxel;
	
    hit = false;
    float hitT = 0.0;
    for(int i=0; i<maxSteps; i++) {
        vec2 d = scene(voxelToWorld(voxel));        
        if (d.x <= isoValue && !hit) {
            hit = true;
	    hitVoxel = voxel;
	    hitColor = matToColor(d.y);
            //break;
        }

        bool c1 = tMax.x < tMax.y;
        bool c2 = tMax.x < tMax.z;
        bool c3 = tMax.y < tMax.z;

        if (c1 && c2) { 
            voxel.x += step.x;
            tMax.x += tDelta.x;
		if (!hit) {
			hitNormal = vec3(-step.x, 0.0, 0.0);
			hitT = tMax.x;
		}
        } else if (c3 && !c1) {
            voxel.y += step.y;
            tMax.y += tDelta.y;
		if (!hit) {
			hitNormal = vec3(0.0, -step.y, 0.0);		
			hitT = tMax.y;
		}
        } else {
            voxel.z += step.z;
            tMax.z += tDelta.z;
		if (!hit) {
			hitNormal = vec3(0.0, 0.0, -step.z);		
			hitT = tMax.z;
		}
        }
     
#if 0
        if ((voxel.x < 0) || (voxel.x >= size.width) ||
            (voxel.y < 0) || (voxel.y >= size.height) ||
            (voxel.z < 0) || (voxel.z >= size.depth)) {
            break;            
        }
#endif	    
    }
	
    return ro + hitT*rd;
    //return voxelToWorld(hitVoxel);
}

// lighting
vec3 shade(vec3 pos, vec3 n, vec3 eyePos, vec3 color)
{
    const vec3 lightPos = vec3(5.0, 10.0, -5.0);
    const float shininess = 80.0;
	
    vec3 l = normalize(lightPos - pos);
    vec3 v = normalize(eyePos - pos);
    vec3 h = normalize(v + l);
    float diff = dot(n, l);
    float spec = max(0.0, pow(dot(n, h), shininess)) * float(diff > 0.0);
    diff = max(0.0, diff);
    //diff = 0.5+0.5*diff;

    float fresnel = pow(1.0 - dot(n, v), 5.0);
    //float ao = ambientOcclusion(pos, n);

    // shadow
    vec3 ro = pos + n*0.2; // offset to avoid self-intersection
    bool shadowHit;
    vec3 hitColor, hitN;
    vec3 hitPos = voxelTrace(ro, l, shadowHit, hitN, hitColor);
    float shadow = shadowHit ? 0.0 : 1.0;

//    return vec3(diff) * color + vec3(spec + fresnel*0.5);
//    return vec3(diff*color);	
    return (vec3(diff*color) + vec3(spec)) * vec3(shadow);
//    return vec3(fresnel);
}

vec3 background(vec3 rd)
{
     //return mix(vec3(1.0), vec3(0.0), rd.y);
     return mix(vec3(1.0, 1.0, 1.0), vec3(0.0, 0.0, 1.0), rd.y);
     //return vec3(0.0);
}

void main(void)
{
    vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    // compute ray origin and direction
    float asp = resolution.x / resolution.y;
    vec3 rd = normalize(vec3(asp*pixel.x, pixel.y, -2.0));
    vec3 ro = vec3(0.0, 0.0, 5.0);
    ro += rd*3.0;
		
    float a;

    //a = sin(time*0.25)*0.3;
    a = -(1.0 - mouse.y)*1.5;
    rd = rotateX(rd, a);
    ro = rotateX(ro, a);
		
    //a = sin(time*0.3)*1.5;
    a = -(mouse.x-0.5)*8.0;
    rd = rotateY(rd, a);
    ro = rotateY(ro, a);

    // trace ray
    bool hit;
    vec3 n;
    vec3 hitColor;
    vec3 pos = voxelTrace(ro, rd, hit, n, hitColor);

    vec3 rgb;
    if(hit)
    {	    
        // shade
        rgb = shade(pos, n, ro, hitColor);
	//rgb = pos*0.5+0.5;

#if 0
        // reflection
        vec3 v = normalize(ro - pos);
        float fresnel = 0.1 + 0.4*pow(1.0 - dot(n, v), 5.0);

        ro = pos + n*0.01; // offset to avoid self-intersection
        rd = reflect(-v, n);
        //pos = trace(ro, rd, hit);
	pos = voxelTrace(ro, rd, hit, n, hitColor);
	    
        if (hit) {
            rgb += shade(pos, n, ro, hitColor) * vec3(fresnel);
        } else {
            rgb += background(rd) * vec3(fresnel);
        }
#endif 

     } else {
        rgb = background(rd);
     }

    // vignetting
    //rgb *= 0.5+0.5*smoothstep(2.0, 0.5, dot(pixel, pixel));
	
    rgb = pow(rgb, vec3(1.0 / 2.2));

    gl_FragColor=vec4(rgb, 1.0);
}