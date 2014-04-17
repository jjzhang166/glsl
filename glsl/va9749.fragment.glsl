#ifdef GL_ES http://glsl.heroku.com/e#9215.0 
precision mediump float;
#endif 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float EPSILON = 0.00005;

struct Camera
{
	vec3 position;
	vec3 dir;
	vec3 up;
	vec3 rayDir;
};

struct MapResult
{
	float dist;
	vec3 color;
};
	
struct MarchResult
{
	vec3 position;
	float dist;
	vec3 color;
};

vec4 thankyouforthis(vec3 pos); //sphinx
vec3 howitworks();

float SoftMax(float a, float b, float k);
float SoftMin(float a, float b, float k);
float smoothcurve(float f);
mat4 rotationMatrix(vec3 axis, float angle);
vec3 opCheapBend(vec3 p, float x, float y);
vec3 opTwist(vec3 p, float x, float y);
MapResult map_thing(vec3 position);
MapResult map(vec3 position);
vec3 getColor(const in Camera cam, const in vec3 position, const in float dist, const in vec3 color);
MarchResult raymarch(const in Camera cam);
Camera getCamera();


void main() 
{	
	Camera cam = getCamera();
	MarchResult result = raymarch(cam);
	
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	float display = step(1., length(8.*floor(2.*(2.*fract(uv)))));
	
	vec3 color = result.color; 
	
	if(display < 1.){
		color = howitworks(); //this simple function is folded on itself to create the landscape - sphinx
	}
	
	gl_FragColor = vec4(color, 1.0);
}


float smoothcurve(float f) {
	return 0.5*(1.0+cos(3.14*f));
}


float SoftMax(float a, float b, float k)
{
	return log(exp(k*a)+exp(k*b))/k;
}

float SoftMin(float a, float b, float k)
{
	return -(log(exp(k*-a)+exp(k*-b))/k);
}

mat4 rotationMatrix(vec3 axis, float angle)
{
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, 0.0,
		    oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, 0.0,
		    oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c, 0.0,
		    0.0, 0.0, 0.0, 1.0);
}

vec3 opCheapBend(vec3 p, float x, float y)
{
    float c = cos(x*p.y);
    float s = sin(y*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec3  q = vec3(m*p.xy,p.z);
    return q;
}

vec3 opTwist(vec3 p, float x, float y)
{
    float c = cos(x*p.y);
    float s = sin(y*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec3  q = vec3(m*p.xz,p.y);
    return q;
}


MapResult map_thing(vec3 position)
{
	MapResult result;
	
	vec4 thing =  thankyouforthis(-position);
	
	thing *= thing * thing;
	
	thing =  0.5 + normalize(thing);
	
	vec3 c0 = vec3(.085, .38, .35);
	vec3 c1 = vec3(.25, .15, .84);
	
	vec3 ca = vec3(.3, .252, .1);
	
	vec3 m0 = normalize(cross(thing.xzy * thing.zzz, thing.zxy)) ;
	vec3 m1 = normalize(cross(thing.xzy * thing.yzz, thing.zxy));
	
	result.color = mix(c0, c1, (m0+m1)*.5) + ca;
	
	result.dist = length(position) * length(thing.xyz) * .01;

	
	return result;
}

MapResult map(vec3 position)
{
	MapResult result;
	
	MapResult thing = map_thing(position);
	
	result = thing;
	
	return result;
}

vec3 getColor(const in Camera cam, const in vec3 position, const in float dist, const in vec3 color)
{	
	vec3 eps = vec3(EPSILON, 0, 0);
	
	vec3 normal=normalize(
		   vec3(dist - map(position-eps.xyy).dist,
			dist - map(position-eps.yxy).dist,
			dist - map(position-eps.yyx).dist));
	
	float lambert = dot(normal, -cam.rayDir);
	
	return lambert * color;
}

MarchResult raymarch(const in Camera cam)
{
	MarchResult result;
	result.color = vec3(0);
	
	const int MAX_ITERATIONS = 8;
	const float MAX_DEPTH = 8.0;
	
	float depth = 0.0;
	MapResult mapping;
	for(int i = 0; i < MAX_ITERATIONS; ++i)
	{
		result.position = cam.position + cam.rayDir * depth;
		mapping = map(result.position);
		
		if(mapping.dist <= EPSILON)
		{
			break;
		}
		
		depth += mapping.dist;
				
		if(depth > MAX_DEPTH)
		{
			break;
		}
	}
	
	result.dist = mapping.dist;
	
	if(depth < MAX_DEPTH)
		result.color = getColor(cam, result.position, result.dist, mapping.color);

	return result;
}

Camera getCamera()
{
	Camera cam;
  	cam.dir = vec3(0,0,0);
	float t = 0.15;
	cam.position = vec3(sin(t + 1.0)*1.0, 1, cos(t)*1.0);
	cam.up = vec3(0,1,0);
  	vec3 forward = normalize(cam.dir - cam.position);
  	vec3 left = cross(forward, cam.up);
 	cam.up = cross(left, forward);
 
	vec3 screenOrigin = (cam.position+forward);
	vec2 screenPos = 2.0*gl_FragCoord.xy/resolution.xy - 1.0;
 	float screenAspectRatio = resolution.x/resolution.y;
	vec3 screenHit = screenOrigin + screenPos.x * left * screenAspectRatio + screenPos.y * cam.up;
  
	cam.rayDir = normalize(screenHit-cam.position);
	return cam;
}

// public domain
#define N 16
#define PI2 (3.14159265*2.0)

float  tri( float x ){
	return (abs(fract(x)-0.5)-0.25);
}
vec3 tri( vec3 p ){
	return vec3( tri(p.x), tri(p.y), tri(p.z) );
}

vec4 thankyouforthis( vec3 pos ) {
	vec3 v = 0.1 * pos - vec3( (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 1.5, 0.0);
	
	float mx = pos.y - sin(time * 0.00037312 + mouse.x) * 15.25 + .5;
	float my = pos.x - cos(time * 0.00023312 + mouse.y) * 13.25 + .5;
	
	float c1 = cos(my * PI2);
	float s1 = sin(my * PI2);
	float c2 = cos(mx * PI2);
	float s2 = sin(mx * PI2);
	float c3 = cos(.5 * mouse.x + .5 * PI2);
	float s3 = sin(.5 * mouse.y + .5 * PI2);
	vec3 vsum = vec3(0.0);
	
	for ( int i = 0; i < N; i++ ){
		float f = float(i) / float(N);
		
		v *= 1. + 0.1/(f*f+0.2);
		v += (pos.z)+.15;
		v = vec3( v.x*c1-v.y*s1, v.y*c1+v.x*s1, v.z ); // rotate
		v = vec3( v.x, v.y*c2-v.z*s2, v.z*c2+v.y*s2 ); // rotate
		v = vec3( v.x*c3-v.z*s3, v.y, v.z*c3+v.x*s3 ); // rotate
		v = tri( v ); // fold
		vsum += .25 * cos(pos.z) / (v+1.);
		vsum *= 1.25;
	
	}
	v = min(vec3(1.), max(vec3(0.), vsum *.0001));
	
	return vec4( sin(v * PI2 * 6.0)*.12 + .5, 1.0 );
}

vec3 howitworks() {
	vec3 v = 4. * vec3( (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 1.5, 0.0);
	v.z = time*.01;
	
	float mx = sin(1.32 + time * 0.0037312) * 1.45 + 0.5;
	float my = cos(1.01 + time * 0.0023312) * 1.45 + 0.5;
	
	float c1 = cos(my * PI2);
	float s1 = sin(my * PI2);
	float c2 = cos(mx * PI2);
	float s2 = sin(mx * PI2);
	float c3 = cos(mouse.x * PI2);
	float s3 = sin(mouse.x * PI2);
	vec3 vsum = vec3(0.0);
	

	for ( int i = 0; i < 1; i++ ){ //1 fold - try changing it to 8...
		float f = float(i) / float(N);
		
		v *= 1.0 + 0.1/(f*f+0.45);
		v += (mouse.y-.5)*2.0;
		v = vec3( v.x*c1-v.y*s1, v.y*c1+v.x*s1, v.z ); // rotate
		v = vec3( v.x, v.y*c2-v.z*s2, v.z*c2+v.y*s2 ); // rotate
		v = vec3( v.x*c3-v.z*s3, v.y, v.z*c3+v.x*s3 ); // rotate
		v = tri( v ); // fold
		vsum += v;
		vsum *= 0.9;
	
	}
	v = vsum *.3;
	
	return vec3(sin(v * PI2 * 4.0)*.5+.5);
}