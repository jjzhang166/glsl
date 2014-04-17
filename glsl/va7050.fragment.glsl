#ifdef GL_ES
precision highp float;
#endif

// Raytracer from http://www.youtube.com/watch?v=9g8CdctxmeU&feature=share&list=PL4F596435B3FAF89E

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere(in vec3 ro, in vec3 rd, in vec4 sph)
{
	// Sphere centered at the origin has equation |xyz| = r (r is radius)
	// |xyz|^2 = r^2
	// xyz = ro + t * rd --> |ro|^2 + t^2 + 2*<ro, rd>*t - r^2 = 0
	// quadratic equation
	vec3 oc = ro - sph.xyz;
	float r = 1.0;
	float b = 2.0 * dot(oc, rd);
	float c = dot(oc, oc) - sph.w * sph.w;
	float h = b * b - 4.0 * c;
	if(h < 0.0)
	{
		return -1.0;
	}
	float t = (-b - sqrt(h))/2.0;
	return t;
}
vec3 nSphere(in vec3 pos, in vec4 sph)
{
	return (pos - sph.xyz)/sph.w;
}


float iPlane(in vec3 ro, in vec3 rd)
{
	return -ro.y/rd.y;
}
vec3 nPlane(in vec3 pos)
{
	return vec3(0.0, 1.0, 0.0);
}



vec4 sph1 = vec4(0.0, 1.0, 0.0, 1.0);
float intersect(in vec3 ro, in vec3 rd, out float resT)
{
	resT = 100.0;
	float id = -1.0;
	float t = -1.0;
	float tsph1 = iSphere(ro, rd, sph1);
	float tpla = iPlane(ro, rd);
	if(tsph1 > 0.0)
	{
		id = 1.0;
		resT = tsph1;
	}
	if(tpla > 0.0 && tpla < resT)
	{
		id = 2.0;
		resT = tpla;
	}
	
	return id;
}

void main( void )
{

	vec3 light = normalize(vec3(0.25, 1.0, 0.5));
	vec2 uv = gl_FragCoord.xy/resolution;

	vec3 ro = vec3( 0.0, 1.0, 10.0);
	float aspectX = resolution.x/resolution.y;
	vec3 rd = normalize(vec3( (-1.0 + 2.0 * uv) * vec2(aspectX, 1.0), -1.0));

	sph1.x = 2.5 * cos(time);
	sph1.z = 2.5 * sin(time);
	sph1.y = 2.0;
	sph1.w = clamp(1.0 + sin(2.0 * time) * 0.5, 0.0, 2.0);
	
	float t;
	float id = intersect(ro, rd, t);

	vec3 color = vec3(0.0);

	if( id > 0.0 && id < 2.0)
	{
		vec3 pos = ro + t * rd;
		vec3 nor = nSphere(pos, sph1);
		float dif = clamp( dot(nor, light), 0.0, 1.0);
		float amb = 0.5 + 0.5 * nor.y;
		color.xyz = vec3(1.0, 0.8, 0.6) * dif + amb * vec3(0.2, 0.3, 0.4);
	}
	if(id > 1.0 && id < 3.0)
	{
		vec3 pos = ro + t * rd;
		vec3 nor = nPlane(pos);
		float dif = clamp( dot(nor, light), 0.0, 1.0);
		float amb = smoothstep(0.0, 2.0 * sph1.w, length(pos.xz - sph1.xz));
		color.xyz =vec3(amb * 0.6);
	}
	color = sqrt(color);

	gl_FragColor.xyz = color;
}