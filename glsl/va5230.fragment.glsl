#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere(in vec3 ro, in vec3 rd, vec4 sph) {
	
	// a sphere centered at the origin has equation |xyz| = r    -> sqrt(x^2 + y^2 + z^2) = r  -> x^2 + y^2 + z^2 = r^2
	// therefore |xyz|^2 = r^2  meaning <xyz, xyz> = r^2
	// for the ray   xyz = ro + t*rd    therefore   |ro|^2 + t^2 + 2*<ro, rd>t = r^2   
	// (a+b*t) * (a+b*t)  = a*a + t^2 + 2*a*b*t => dot(a, a) + t^2 + 2*dot(a, b)*t = r^2  => t^2 + 2*dot(a, b)*t + dot(a, a) - r^2 = 0
	
	vec3 raySphere = ro-sph.xyz;
	
	float a = 1.0;
	float b = 2.0*dot(raySphere, rd);
	float c = dot(raySphere, raySphere) - sph.w*sph.w;
	
	float h = b*b - 4.0*a*c; 
	
	if(h<0.0) 
		return -1.0;
	else
		return (-b - sqrt(h))/(2.0*a);
}

vec3 nSphere(in vec3 pos, vec4 sph) {
	return (pos.xyz-sph.xyz)/sph.w;
}

float iPlane(in vec3 ro, in vec3 rd) {

	// equation of a plane y=0  ro.y + rd.y*t = 0 -> -ro.y = rd.y*t  => -ro.y/rd.y = t;
	
	return -ro.y/rd.y;
}

vec3 nPlane(vec3 pos) {
	return vec3(0.0, 1.0, 0.0);
}

vec4 sph = vec4(0.0, 1.0, 0.0, 1.0);

float intersect(in vec3 ro, in vec3 rd, out float z) {
	
	float id = -1.0;
	
	z = 1000.0;
	
	float tSphere = iSphere(ro, rd, sph);
	float tPlane = iPlane(ro, rd);
	
	if(tPlane > 0.0 && tPlane < z) 
	{
		z = tPlane;
		id = 0.0;
	}
	if(tSphere > 0.0 && tSphere < z) {
		z = tSphere;
		id = 1.0;
	}
	
	return id;
}

void main( void ) {

	vec3 lightDir = normalize(vec3(sin(time), 1.0, cos(time)));
	
	vec2 screen = (gl_FragCoord.xy / resolution.xy);
	vec2 uv = (screen*2.0 -1.0)*vec2(1.77, 1.0);
	
	// generate ray with origin ro and direction rd
	
	vec3 ro = vec3(0.0, 1.0, 3.0);
	vec3 rd = normalize( vec3(uv, -1.0) );
	
	// intersect the ray with the scene
	float z = 0.0;
	float id = intersect(ro, rd, z);
	
	vec3 c = vec3(0.0);
	
	if(id > -0.5 && id < 0.5) {
		vec3 pos = ro+rd*z;
		
		vec3 n = nPlane(pos);
		
		float shadowDepth = iSphere(pos, lightDir, sph);
		
		float diffuse = dot(n, lightDir);
		vec3 color = vec3(0.0, 0.0, 1.0);
		
		c = color*diffuse;
		
		if(shadowDepth > 0.0)
			c *= shadowDepth*0.4;
	}
	if(id > 0.5) {
		vec3 pos = ro+rd*z;
		vec3 n = nSphere(pos, sph);
		
		float diffuse = dot(n, lightDir);
		c = vec3(1.0, 0.0, 0.0);
		c *= diffuse;
	}
	
	
	
	gl_FragColor = vec4(c,0);

}