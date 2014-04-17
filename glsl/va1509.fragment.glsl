#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Check sphere intersection
bool iSphere(vec3 ro, vec3 rd, vec3 center, float radius, out float dist) {
	//A B and C
	float a = dot(rd, rd);
	float b = 2.0 * dot(rd, ro);
	float c = dot((ro - center), (ro - center)) - (radius * radius);
	
	float disc = b * b - 4.0 * a * c;
	
	//We need real roots
	if (disc < 0.0) {
		return false;
	}
	
	//Calc
	float q;
	if (b < 0.0) {
		q = (-b - disc) / 2.0;
	} else {
		q = (-b + disc) / 2.0;	
	}
	
	float t0 = q / a;
	float t1 = c / q;
	
	if (t0 > t1) {
		float temp = t1;
		t0 = t1;
		t0 = temp;
	}
	
	if (t1 < 0.0) {
		return false;	
	}
	
	if (t0 < 0.0) {
		dist = t1;
		return true;
	} else {
		dist = t0;
		return true;
	}
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec3 ro = vec3(0.5, 0.5, 0.0);
	vec3 rd = normalize(vec3(uv, 1.0) - ro);
	
	float dist;
	
	bool intersects = iSphere(ro, rd, vec3(0.5, 0.5, 0.0), 0.5, dist);
	
	vec3 color = vec3(0.0);
	
	if (intersects) {
		color = vec3(1.0);
	}
	
	
	gl_FragColor = vec4(color, 1.0);

}