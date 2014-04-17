#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;
const int MAX_RAYMARCH_ITER = 200;
const float MIN_RAYMARCH_DELTA = 0.0001;

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}

float map(vec3 p, vec3 ray_dir) 
{ //  ray_dir is used only for some optimizations
    float plane = sdPlane(p + vec3(0,0.3,0), vec4(normalize(vec3(0, 1, -0.5)),0));

    if (ray_dir.z <= 0.0 || p.z < 1.0) { // Optimization: try not to compute blobby object distance when possible
        float sphere1 = sdSphere(p + vec3(cos(time * 0.2 + PI) * 0.45,0,0), 0.25);
	float Rbox  = udRoundBox(p + vec3(cos(time * 0.2 + PI) * 0.45,0,0), vec3(0.1,0.1,0.1), 0.01);
        return min(min(Rbox,sphere1), plane);
    } else {
        return plane;
    }
}
bool raymarch(vec3 ray_start, vec3 ray_dir, out float dist, out vec3 p, out int iterations) 
{
    dist = 0.0;
    float minStep = 0.0001;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) 
    {
        p = ray_start + ray_dir * dist;
        float mapDist = map(p, ray_dir);
        if (mapDist < MIN_RAYMARCH_DELTA) 
	{
           iterations = i;
           return true;
        }
        if(mapDist < minStep) { mapDist = minStep; }
	    
        dist += mapDist;
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}


void main( void ) 
{
    vec3 light_pos = vec3(-0.5 + sin(time), 1.0, -1.0 + cos(time * 0.5) * 2.0);	

    vec2 position = vec2((gl_FragCoord.x - resolution.x / 2.0) / resolution.y, (gl_FragCoord.y - resolution.y / 2.0) / resolution.y);
    vec3 ray_start = vec3(0, 0, -2);
    vec3 ray_dir = normalize(vec3(position,0) - ray_start);
    	
    float dist; vec3 p; int iterations;
	
    if (raymarch(ray_start, ray_dir, dist, p, iterations)) 
    {
        float d2; vec3 p2; int i2;
    
	float diffuse = dist/10.0;	    
	vec4 color = vec4(vec3(0.9,0.8,0.6) * diffuse, 1);
	gl_FragColor = color;
    }
    else
    {
        gl_FragColor = vec4( 1,1,1, 1.0 );
    }

}