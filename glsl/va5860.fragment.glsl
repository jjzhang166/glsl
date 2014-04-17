// Ray Marching (Sphere Tracing) experiment by Riccardo Gerosa aka h3r3 
// Blog: http://www.postronic.org/h3/ G+: https://plus.google.com/u/0/117369239966730363327 Twitter: http://twitter.com/#!/h3r3
// This GLSL shader is based on the awesome work of JC Hart and I Quilez. Features two lights with soft shadows, blobby objects, object space ambient occlusion.

// modified to include a cellular noise type thing inspired by leizex

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159;
const int MAX_RAYMARCH_ITER = 50;
const float MIN_RAYMARCH_DELTA = 0.0015;
const float GRADIENT_DELTA = 0.002;
const float SOFT_SHADOWS_FACTOR = 3.0;

float sdSphere(vec3 p, float s) {
    return length(p) - s;
}

float sdTorus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

float sdPlane(vec3 p, vec4 n) { // n must be normalized
    return dot(p, n.xyz) + n.w;
}

float blend(float d1, float d2) {
    float dd = cos((d1 - d2) * PI);
    return mix(d1, d2, dd);
}

vec3 n( vec3 seed ) {
	float t = sin(seed.x+seed.y*1e3+seed.z*5798.0);
	return vec3(fract(t*1e4), fract(t*1e6), fract(t*1e7));
}

vec2 cn(vec3 p) {
	vec3 i = floor(p);
	vec3 f = p-i;
//	vec3 f = smoothstep(0., 1., p-i);
	vec2 r = vec2(1.0);
	for (float z = -1.; z <= 1.; ++z) {
		for (float y = -1.; y <= 1.; ++y) {
			for (float x = -1.; x <= 1.; ++x) {
				vec3 c = (n((i+vec3(x, y, z)))*.5+.5) + vec3(x, y, z) - f;
				float d = dot(c, c);
				if (d < r.x) {
					r.y = r.x;
					r.x = d;
				} else if (d < r.y) {
					r.y = d;
				}
			}
		}
	}
	return sqrt(r);
}   

float oldmap(vec3 p, vec3 ray_dir) {
	float ttime=3.6;
	float plane = sdPlane(p + vec3(0,0.3,0), vec4(normalize(vec3(0, 1, -0.5)),0));
    if (ray_dir.z <= 0.0 || p.z < 1.0) { // Optimization: try not to compute blobby object distance when possible
        float sphere1 = sdSphere(p + vec3(cos(ttime * 0.2 + PI) * 0.45,0,0), 0.25);
        float sphere2 = sdSphere(p + vec3(cos(ttime * 0.2) * 0.45,0,0), 0.25);
        float torus = sdTorus(vec3(p.y + sin(ttime) *0.1, p.z + cos(ttime) * 0.1, p.x), vec2(0.2, 0.08));
        return min(min(blend(sphere1, torus), blend(sphere2, torus)), plane);
    } else {
        return plane;
    }

}

vec2 map(vec3 p, vec3 ray_dir) { //  ray_dir is used only for some optimizations
    vec2 dd =cn(p*20.1);
	float diff = dd.y-dd.x;
	
	//diff=smoothstep(0.0,1.0,diff);
	return vec2(oldmap(p,ray_dir) - 0.03 * diff, diff);
/*	
	
*/
}

float map(vec3 p) {
    return map(p, vec3(0,0,0)).x;
}

vec3 gradientNormal(vec3 p) {
    return normalize(vec3(
        map(p + vec3(GRADIENT_DELTA, 0, 0)) - map(p - vec3(GRADIENT_DELTA, 0, 0)),
        map(p + vec3(0, GRADIENT_DELTA, 0)) - map(p - vec3(0, GRADIENT_DELTA, 0)),
        map(p + vec3(0, 0, GRADIENT_DELTA)) - map(p - vec3(0, 0, GRADIENT_DELTA))));
}

bool raymarch(vec3 ray_start, vec3 ray_dir, out float dist, out vec3 p, out int iterations) {
    dist = 0.0;
    float minStep = 0.0001;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) {
        p = ray_start + ray_dir * dist;
        float mapDist = map(p, ray_dir).x;
        if (mapDist < MIN_RAYMARCH_DELTA) {
           iterations = i;
           return true;
        }
        if(mapDist < minStep) { mapDist = minStep; }
        dist += mapDist * 0.79;
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

bool raymarch_to_light(vec3 ray_start, vec3 ray_dir, float maxDist, out float dist, out vec3 p, out int iterations, out float light_intensity) {
    dist = 0.0;
    float minStep = 0.0001;
    light_intensity = 1.0;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) {
        p = ray_start + ray_dir * dist;
        float mapDist = map(p, ray_dir).x;
        if (mapDist < MIN_RAYMARCH_DELTA) {
            iterations = i;
            return true;
        }
        light_intensity = min(light_intensity, SOFT_SHADOWS_FACTOR * mapDist / dist);
        if(mapDist < minStep) { mapDist = minStep; }
        dist += mapDist;
        if (dist >= maxDist) { break; }
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

float ambientOcclusion(vec3 p, vec3 n) {
    float step = 0.03;
    float ao = 0.0;
    float dist;
    for (int i = 1; i <= 3; i++) {
        dist = step * float(i);
        ao += (dist - map(p + n * dist)) / float(i * i);
    }
    return ao;
}

void main( void ) {
    vec2 position = vec2((gl_FragCoord.x - resolution.x / 2.0) / resolution.y, (gl_FragCoord.y - resolution.y / 2.0) / resolution.y);
    vec3 ray_start = vec3(0, 0, -2);
    vec3 ray_dir = normalize(vec3(position,0) - ray_start);

    float angleX = (mouse.y -0.5) * 0.5;
    float angleY = (mouse.x -0.5);
    float angleZ = (mouse.x -0.5) * 0.1;
    mat3 rotateX = mat3(1.0, 0.0, 0.0,
                        0.0, cos(angleX), -sin(angleX),
                        0.0, sin(angleX), cos(angleX));
    mat3 rotateY = mat3(cos(angleY), 0.0, sin(angleY),
                        0.0, 1.0, 0.0,
                        -sin(angleY), 0.0, cos(angleY));
    mat3 rotateZ = mat3(cos(angleZ), -sin(angleZ), 0.0,
                        sin(angleZ), cos(angleZ), 0.0,
                        0.0, 0.0, 1.0);
    ray_dir = ray_dir * rotateX * rotateY * rotateZ;
    ray_start.x = -mouse.x * 3.0 + 1.5;
    ray_start.y = mouse.y * 1.0 - 0.5;

   float ttime=3.0;
    vec3 light1_pos = vec3(-0.5 + sin(ttime), 1.0, -1.0 + cos(ttime * 0.5) * 2.0);
    vec3 light2_pos = vec3(sin(ttime * 1.9 + 2.0) * 0.6, sin(ttime * 1.8) + 5.0, -0.5 + sin(ttime * 1.6) * 0.5);
    vec4 color;
    float dist; vec3 p; int iterations;
    if (raymarch(ray_start, ray_dir, dist, p, iterations)) {
	float ao = map(p,vec3(0,0,0)).y;
	    ao=1.0-ao;
	    ao=ao*ao*0.7;
	    ao=1.0-ao;
        vec3 n = gradientNormal(p);
	    color = vec4(ao*(n*0.5+0.5),1);
        
    } else {
        color = vec4(0,0,0,0);
    }
    gl_FragColor = color;
}