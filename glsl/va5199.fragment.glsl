#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D fft;
uniform vec4 unPar;
uniform vec4 unPos;
uniform vec3 unBeatBassFFT;

struct ray {
	vec3 origin;
	vec3 direction;
};

float iSphere(in ray r, in vec4 sph) {
	vec3 oc = r.origin - sph.xyz;
	float b = 1.0*dot(oc, r.direction);
	float c = dot(oc, oc) - sph.w*sph.w;
	float h = b*b - 4.0*c;
	if(h < 0.0 ) return -1.0;
	return (-b - sqrt(h))/2.0;
}

vec3 nSphere ( in vec3 pos, in vec4 sph )
{
	return (pos-sph.xyz)/sph.w;	
}

float iPlane( in ray r) {
	return -r.origin.y/r.direction.y;	
}

vec3 nPlane ( in vec3 pos )
{
	return vec3(0.0, 1.0, 0.0);
}

vec4 sph1 = vec4(0.0, 1.0, 0.0, 1.0);
float intersect(in ray r, out float resT) {
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere(r, sph1);
	float tpla = iPlane(r);
	if( tsph > 0.0) {
		id = 1.0;
		resT = tsph;
	}
	if( tpla > 0.0 && tpla < resT) {
		id = 2.0;
		resT = tpla;
	}
	
	return id;
}

void main( void ) {
	
	vec3 light = normalize( vec3(0.57703));
	//pixel coordinates
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	
	sph1.x = 2.0*cos(time);
	sph1.z = 2.0*sin(time) - 2.0;
	
	//ray
	ray r = ray(vec3(0.0, 1.0, 3.0), normalize(vec3(-1.0 + 2.0*uv, -1.0)) );
	
	vec3 col = vec3(0.7);
	float t;
	float id = intersect(r, t);
	if( id > 0.5 && id < 1.5) 
	{
		vec3 pos = r.origin + t* r.direction;
		vec3 nor = nSphere( pos, sph1 );
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float amb = 0.5 + 0.5*nor.y;
		col = vec3(1.0, 0.8, 0.6)*dif*amb +  vec3(0.1, 0.2, 0.4)*amb;	
	}
	else if( id > 1.5)
	{
		vec3 pos = r.origin + t*r.direction;
		vec3 nor = nPlane(pos);
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float amb = smoothstep(0.0, 2.0*sph1.w, length(pos.xz-sph1.xz) );
		col = amb * vec3(amb*0.7);
	}
	col = sqrt(col);
	gl_FragColor = vec4(col, 1.0 );

}