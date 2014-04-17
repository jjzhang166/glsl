// Tron light cycle - work in progress!
// @simesgreen
// 
// Original by MAGI, 57 CSG primitives
// this version based on Carl Hoff's POVray model:
// http://www.wwwmwww.com/Matt/cyclev4z.pov
// http://www.tron-sector.com/forums/default.aspx?a=top&id=336281&pg=4

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

// CSG operations
float _union(float a, float b)
{
    return min(a, b);
}

float _union(float a, float b, inout float m, float nm)
{
    m = (b < a) ? nm : m;
    return min(a, b);		
}

float intersect(float a, float b)
{
    return max(a, b);
}

float difference(float a, float b)
{
    return max(a, -b);
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

// primitive functions
// these all return the distance to the surface from a given point

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float plane(vec3 p, vec3 n, vec3 pointOnPlane)
{	
  return dot(p, n) - dot(pointOnPlane, n);
}

// plane in z defined by 2d edge
float edge(vec3 p, vec2 a, vec2 b)
{
   vec2 e = b - a;
   vec3 n = normalize(vec3(e.y, -e.x, 0.0));
   return plane(p, n, vec3(a, 0.0));
   //return intersect( plane(p, n, vec3(a, 0.0)), plane(p, -n, vec3(a, 0.0))-0.1);
}

float sdBox( vec3 p, vec3 b )
{
  vec3  di = abs(p) - b;
  float mc = max(di.x, max(di.y, di.z));
  return min(mc,length(max(di,0.0)));
}

float sdCylinder( vec3 p, vec3 c )
{
  return length(p.xz-c.xy)-c.z;
}

float sphere(vec3 p, float r)
{
    return length(p) - r;
}

float box(vec3 p, vec3 bmin, vec3 bmax)
{
   vec3 c = (bmin + bmax)*0.5;
   vec3 size = (bmax - bmin)*0.5;
   return sdBox(p - c, size);
}

// given segment ab and point c, computes closest point d on ab
// also returns t for the position of d, d(t) = a + t(b-a)
vec3 closestPtPointSegment(vec3 c, vec3 a, vec3 b, out float t)
{
    vec3 ab = b - a;
    // project c onto ab, computing parameterized position d(t) = a + t(b-a)
    t = dot(c - a, ab) / dot(ab, ab);
    // clamp to closest endpoint
    t = clamp(t, 0.0, 1.0);
    // compute projected position
    return a + t * ab;
}

// generic capsule
float capsule(vec3 p, vec3 a, vec3 b, float r)
{
    float t;
    vec3 c = closestPtPointSegment(p, a, b, t);
    return length(c - p) - r;
}

// http://www.povray.org/documentation/view/3.6.0/278/
float cylinder(vec3 p, vec3 a, vec3 b, float r)
{
    vec3 ab = b - a;
    // project c onto ab, computing parameterized position d(t) = a + t(b-a)
    float t = dot(p - a, ab) / dot(ab, ab);
    vec3 c = a + t*ab;
		
    float d = length(c - p) - r;
    
    vec3 n = normalize(ab);
    d = intersect(d, plane(p, n, b));
    d = intersect(d, plane(p, -n, a));
    return d;
}

float sdCone( vec3 p, vec2 c )
{
    // c must be normalized
    float q = length(p.xy);
    return dot(c,vec2(q,p.z));
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float torus(vec3 p, float r, float r2)
{
  return sdTorus(p, vec2(r, r2));	
}

// http://www.povray.org/documentation/view/3.6.1/277/
float cone(vec3 p, vec3 a, float baseR, vec3 b, float capR)
{
    vec3 ab = b - a;
    // project c onto ab, computing parameterized position d(t) = a + t(b-a)
    float t = dot(p - a, ab) / dot(ab, ab);
    //t = clamp(t, 0.0, 1.0);
    vec3 c = a + t*ab;	// point on axis

    float r = mix(baseR, capR, t);
    float d = length(c - p) - r;
    d *= 0.5;    
    vec3 n = normalize(ab);
    d = intersect(d, plane(p, n, b));
    d = intersect(d, plane(p, -n, a));
    return d;
}


// model

float front_tire(vec3 p)
{
    return difference( difference(
            sphere(p - vec3(355,85,0), 85.0),
            sphere(p - vec3(355,85,69.4092), 56.6367) ),
            sphere(p - vec3(355,85,-69.4092), 56.6367) );
}

float front_hub(vec3 p)
{
    return difference( 
        box(p, vec3(304.803,34.803,-43.1795), vec3(405.197,135.197,43.1795)),
        _union( sphere(p - vec3(355,85,69.4092), 56.636),
                sphere(p - vec3(355,85,-69.4092), 56.636)));
}

float front_axle(vec3 p)
{
    return _union(
        sphere(p - vec3(355,85,-26), 17.0),
        sphere(p - vec3(355,85,26), 17.0));
}

float rear_tire(vec3 p)
{
    return difference( difference(
        sphere((p - vec3(0,85,0)) * vec3(1,1,5), 85.0) * 0.2,
        sphere(p - vec3(0,85,20.8732), 58.7155) ),
        sphere(p - vec3(0,85,-20.8732), 58.7155) );
}

float rear_axle(vec3 p)
{
    return sphere(p - vec3(0,85,0), 17.0);
}

float rear_hub(vec3 p)
{
    //return box(p, vec3(-55.251,29.749,-1), vec3(55.251,140.251,1));
    return cylinder(p, vec3(0,85,-1.0), vec3(0,85,1), 60.0);
}
	       
float upper_body(vec3 p)
{
    float d = 1e10;
    d = cylinder(p, vec3(192.447,-160,17.5), vec3(192.447,-160.0,-17.5), 389.721);
    d = _union(d, cone(p, vec3(192.447,-160,-17.5), 389.721, vec3(192.447,-160,-22.5), 373.721) );
    d = _union(d, cone(p, vec3(192.447,-160,17.5), 389.721, vec3(192.447,-160,22.5), 373.721) );

    d = intersect(d, edge(p, vec2(434.548,145.401), vec2(434.548,229.721) ));
    d = intersect(d, edge(p, vec2(35.372,145.401), vec2(434.548,145.401) ));
    //d = intersect(d, edge(p, vec2(35.372,60), vec2(434.548,20) ));
	
    //d = intersect(d, edge(p, vec2(6.02735,162.344), vec2(35.372,145.401) ));
    d = intersect(d, edge(p, vec2(6.02735,229.721), vec2(6.02735,162.344) ));	
	
    //d = torus(p.xzy - vec3(192.447,-160, 26.5).xzy, 367.221, 11.5);
    //d = torus(p.xzy - vec3(192.447,-160, -26.5).xzy, 367.221, 11.5);
    return d;
}

float lower_body(vec3 p)
{
    float d;
    d = box(p, vec3(0,38.5,-22.5), vec3(278.689,145.401,22.5));
    //d = difference(d, cylinder(p, vec3(192.447,-160,26.5), vec3(192.447,-160,-26.5), 373.721));
    d = difference(d, cylinder(p, vec3(0,85,26.501), vec3(0,85,-26.501), 28.5));	// axle hole	
    return d;
}

float window(vec3 p)
{
    float d = 1e10;
    d = sphere((p - vec3(238.0,145.4,0.0))/vec3(1.83,0.75,1.0), 77.5)*0.5;
    d = intersect(d, edge(p, vec2(192.447,229.721), vec2(238,145.4)));
    d = intersect(d, edge(p, vec2(335.203,145.4), vec2(381.405,180.848)));
    //d = intersect(d, edge(p, vec2(381.405,229.721), vec2(192.447,229.721)));
    d = intersect(d, edge(p, vec2(192.447,145.4), vec2(381.405,145.4) ));	
//	d = edge(p, vec2(381.405,145.4), vec2(192.447,145.4));
    return d;	
}

// distance to scene
float scene(vec3 p, out float m)
{
#if 0
    // duplicate
    p += vec3(-3.0, 0.0, -3.0);
    p.x = mod(p.x, 6.0);
    p.z = mod(p.z, 6.0);
    p -= vec3(3.0, 0.0, 3.0);
#endif	
		
    float d = 1e10;
    m = 0.0;

#if 1
    p += vec3(2.0, 1.0, 0.0);
    p = p * 100.0;

    d = sdPlane(p, vec4(0, 1, 0, 0)); 

#if 1
    d = _union(d, front_tire(p));
    d = _union(d, front_axle(p), m, 2.0);
    d = _union(d, front_hub(p), m, 1.0);
#endif
	
#if 1
    d = _union(d, rear_tire(p));
    d = _union(d, rear_axle(p), m, 2.0);
    d = _union(d, rear_hub(p), m, 1.0);
#endif
	
    d = _union(d, upper_body(p), m, 0.0);
    d = _union(d, lower_body(p), m, 0.0);
    d = _union(d, cone(p, vec3(293.0,85.0,0.0), 60.0, vec3(219.0,85.0,0.0), 26.5), m, 2.0);

	
    d = _union(d, window(p), m, 1.0);
	
    d /= 100.0;

#else
    //d = sphere(p - vec3(0.0, 2.0, 0.0), 0.1);
    d = cone(p, vec3(0.0, 0.0, 0.0), 1.0, vec3(0.0, 2.0, 0.0), 0.5);
#endif	
    return d;
}

// calculate scene normal
vec3 sceneNormal(in vec3 pos )
{
    float eps = 0.0001;
    vec3 n;
    float m;
    float d = scene(pos, m);
    n.x = scene( vec3(pos.x+eps, pos.y, pos.z), m ) - d;
    n.y = scene( vec3(pos.x, pos.y+eps, pos.z), m  ) - d;
    n.z = scene( vec3(pos.x, pos.y, pos.z+eps), m ) - d;
    return normalize(n);
}

// ambient occlusion approximation
float ambientOcclusion(vec3 p, vec3 n)
{
    const int steps = 3;
    const float delta = 0.5;

    float a = 0.0;
    float weight = 1.0;
    float m;
    for(int i=1; i<=steps; i++) {
        float d = (float(i) / float(steps)) * delta; 
        a += weight*(d - scene(p + n*d, m));
        weight *= 0.5;
    }
    return clamp(1.0 - a, 0.0, 1.0);
}

// lighting
vec3 shade(vec3 pos, vec3 n, vec3 eyePos, float m)
{
    const vec3 lightPos = vec3(5.0, 10.0, 5.0);
    vec3 color = vec3(0.0, 0.5, 1.0);
    const float shininess = 40.0;

    if (m==1.0) {
	color = vec3(0.0);		
    } else if (m==2.0) {
	color = vec3(1.0);
    }
	
    vec3 l = normalize(lightPos - pos);
    vec3 v = normalize(eyePos - pos);
    vec3 h = normalize(v + l);
    float diff = dot(n, l);
    float spec = max(0.0, pow(dot(n, h), shininess)) * float(diff > 0.0);
    //diff = max(0.0, diff);
    diff = 0.5+0.5*diff;

    float fresnel = pow(1.0 - dot(n, v), 5.0);
    float ao = ambientOcclusion(pos, n);

//    return vec3(diff) * color + vec3(spec + fresnel*0.5);	
    return vec3(diff*ao) * color + vec3(spec*0.5);
//    return vec3(diff*ao) * color + vec3(spec);
//    return vec3(ao);
//    return vec3(fresnel);
//    return n*0.5+0.5;
}

// trace ray using sphere tracing
vec3 trace(vec3 ro, vec3 rd, out bool hit, out float m)
{
    const int maxSteps = 64;
    const float hitThreshold = 0.001;
    hit = false;
    vec3 pos = ro;
    vec3 hitPos = ro;

    for(int i=0; i<maxSteps; i++)
    {
        float d = scene(pos, m);
        if (d < hitThreshold) {
            hit = true;
            hitPos = pos;
            //return pos;
        }
        pos += d*rd;
    }
    return hitPos;
}

vec3 background(vec3 rd)
{
     //return mix(vec3(1.0), vec3(0.0), rd.y);
     //return mix(vec3(1.0), vec3(0.0, 0.25, 1.0), rd.y);
     return vec3(0.25);
}

void main(void)
{
    vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    // compute ray origin and direction
    float asp = resolution.x / resolution.y;
    vec3 rd = normalize(vec3(asp*pixel.x, pixel.y, -2.0));
    vec3 ro = vec3(0.0, 0.0, 5.0);

    float roty = -(mouse.x-0.5)*6.0;
    float rotx = min(0.0, (mouse.y-0.5)*5.0);

    rd = rotateX(rd, rotx);
    ro = rotateX(ro, rotx);
		
    rd = rotateY(rd, roty);
    ro = rotateY(ro, roty);
		
    // trace ray
    bool hit;
    float m = 0.0;
    vec3 pos = trace(ro, rd, hit, m);

    vec3 rgb;
    if(hit)
    {
        // calc normal
        vec3 n = sceneNormal(pos);
        // shade
        rgb = shade(pos, n, ro, m);

#if 1
        // reflection
        vec3 v = normalize(ro - pos);
        float fresnel = 0.1 + 0.4*pow(1.0 - dot(n, v), 5.0);

        ro = pos + n*0.01; // offset to avoid self-intersection
        rd = reflect(-v, n);
        pos = trace(ro, rd, hit, m);

        if (hit) {
            vec3 n = sceneNormal(pos);
            rgb += shade(pos, n, ro, m) * vec3(fresnel);
        } else {
            rgb += background(rd) * vec3(fresnel);
        }
#endif 

     } else {
        rgb = background(rd);
     }

    // vignetting
    //rgb *= 0.5+0.5*smoothstep(2.0, 0.5, dot(pixel, pixel));

    gl_FragColor=vec4(rgb, 0.2);
}