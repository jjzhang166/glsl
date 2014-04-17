#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323846264;

const float maxDist = 1000.0;

const vec4 sphere = vec4(0.0, 0.0, 0.0, 1.0);

const vec4 lightSource = vec4(10.0, 10.0, 10.0, 1.0);

float raySphereIntersection(vec3 ro, vec3 rd, float maxDist, vec4 sphere) {
	float r = sphere.w;
	float a = dot(rd, rd);      	// length²
	float b = 2.0 * dot(rd, ro);
	float c = dot(ro, ro) - (r*r);
	
	float disc = b*b - 4.0*a*c; // discriminant
	
	if (disc < 0.0) return maxDist; // no intersections, no real roots.
	
	float distSqrt = sqrt(disc);
	float q;
	if (b < 0.0) q = (-b - distSqrt) / 2.0;
	else         q = (-b + distSqrt) / 2.0;
	
	float t0 = q / a;
	float t1 = c / q;
	
	// make sure t0 < t1
	if (t0 > t1) { float tmp = t0; t0 = t1; t1 = tmp; }
	
	if (t1 < 0.0) return maxDist;
	if (t0 < 0.0) return t1/maxDist;
	else 	      return t0/maxDist;
}

float raySphereShadow(vec3 ro, vec3 rd, vec4 sphere) {
	vec3 c = sphere.xyz - ro;
	vec3 d = dot(rd, c)*rd - c;
	float delta = dot(d, d) - (sphere.w*sphere.w);
	if (delta < 0.0) return 1.0;
	return 0.0;
}

vec3 getSphereNormal(vec3 po, vec4 sphere) {
	return normalize(po - sphere.xyz);
}

vec2 worldIntersect(vec3 ro, vec3 rd, float maxDist) {
	float t = raySphereIntersection(ro, rd, maxDist, sphere);
	return vec2(t, 0.0);
}

float worldShadow(vec3 ro, vec3 rd, float maxDist) {
	return raySphereShadow(ro, rd, sphere);
}

vec3 worldGetNormal(vec3 po, float objectID) {
	return getSphereNormal(po, sphere);
}

vec3 worldGetBackground(vec3 rd) {
	return sin(rd*300.0)*0.1+0.1;
}

void main( void ) {
	
	vec2 pos = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
	vec3 ro = vec3(pos + mouse.xy-0.5, 1.0);
	float k = PI*(45.0/180.0);
	vec3 rd = vec3(sin(pos.x*k), sin(pos.y*k), -1.0*cos(pos.x*k)*cos(pos.y*k));
	
	float visible = worldShadow(ro, rd, maxDist);
	if (visible > 0.0) {
		vec2 ti = worldIntersect(ro, rd, maxDist);
		float t = ti.x; float objectID = ti.y;
		vec3 po = ro + rd*t*maxDist;
		vec3 normal = worldGetNormal(po, objectID);
		rd = rd - 2.0*normal*dot(rd, normal);
		gl_FragColor = vec4( worldGetBackground(rd), 1.0 );
		//gl_FragColor = vec4( dot(normal, normalize(lightSource.xyz)), 0.5, 0.5, 1.0 );
	} else {
		gl_FragColor = vec4( worldGetBackground(rd), 1.0 );
	}
}