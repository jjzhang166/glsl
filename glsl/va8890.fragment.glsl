#ifdef GL_ES
precision mediump float;
#endif

#define MAX_STEPS 20
#define HIT_THRESH 0.01
#define DERIV_OFF 0.0001

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere (vec3 p, vec3 c, float r) {
	return distance (p, c) - r;
}

float cuboid (vec3 p, vec3 c, vec3 s, float r) {
	return length(max(abs(p - c)-s,0.0))-r;
}

float scene (vec3 p) {
	float d = sphere (p, vec3 (0.), 0.2);
	d = max (d, -sphere (p, vec3 (0.2, -0.05, -0.3), 0.2));
	d = min (d, cuboid (p, vec3 (0.5, 0.5, 0.), vec3 (0.2, 0.02, 0.2), 0.1));
	d = min (d, cuboid (p, vec3 (0., 0., 0.7), vec3 (0.5, 0.5, 0.3), 0.3));
	return d;
}
vec3 sceneNormal (vec3 p) {
	vec3 checks = vec3 (
		scene (p + vec3 (DERIV_OFF, 0., 0.)),
		scene (p + vec3 (0., DERIV_OFF, 0.)),
		scene (p + vec3 (0., 0., DERIV_OFF))
	);
	checks -= scene (p);
	return normalize (checks);
}

void trace (inout vec3 p, in vec3 d,  out bool hit, out vec3 norm, out float o) {
	norm = vec3 (0.);
	hit = false;
	o = 1.;
	for (int i = 0; i < MAX_STEPS; i++) {
		if (hit) continue;
		float dist = scene (p);
		if (dist < HIT_THRESH) {
			hit = true;
			norm = sceneNormal (p);
		} else {
			o *= 0.98;;
			p += d * dist;
		}
	}
}

float shadow (vec3 p, vec3 d, float k) {
	float shadfac = 1.;
	float trav = 0.;
	
	p += d * 5. * HIT_THRESH;
	trav += 5. * HIT_THRESH;
	
	for (int i = 0; i < MAX_STEPS; i++) {
		float dist = scene (p);
		if (dist < HIT_THRESH) {
			return 0.;
		} else {
			p += d * dist;
			trav += dist;
			shadfac = min (shadfac, k * dist / trav);
		}
	}
	return shadfac;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;
	position.x *= resolution.x / resolution.y;
	
	vec3 camPos  = vec3 (0., 0., -1.);
	camPos.xy += (-mouse*2. + 1.)*0.4;
	camPos = normalize(camPos);
	vec3 camTarget = vec3 (0., 0., 0.);
	vec3 camLook = normalize(camTarget - camPos);
	camLook.xy -= (-mouse*2. + 1.)*0.1;
	
	vec3 camUp = vec3 (0., 1., 0.);
	vec3 camRight = cross (camLook, camUp);
	camUp = cross (camLook, camRight);
	
	camRight = normalize (camRight);
	camUp = normalize (camUp);
	
	vec3 rayDir = camLook + camRight * position.x + camUp * position.y;
	rayDir = normalize (rayDir);
	
	vec3 c = vec3 (0.5);
	
	bool hit = false;
	vec3 checkPoint = camPos;
	vec3 norm;
	float o;
	trace (checkPoint, rayDir, hit, norm, o);
	
	if (hit) {
		vec3 mouseVec = normalize(vec3(-mouse*2. + 1., -0.5));
		vec3 lightVec = normalize(vec3 (-0.8, -1., -0.3));
		vec3 light1 = shadow (checkPoint, mouseVec, 5.) * vec3 (1., 0.5, 1.) * max(0., dot (norm, mouseVec)) * 0.4;
		vec3 light2 = shadow (checkPoint, lightVec, 5.) * vec3 (1., 0.7, 0.3) * max(0., dot (norm, lightVec)) * 0.6;
		vec3 rim = vec3 (0.1, 0.4, 0.5) * pow(1.0+dot(norm,rayDir),4.0);
		c = vec3 (0.4, 0.47, 0.5) + light1 + light2 + rim;
		c *= o;
	}
	c *= 1. - pow(length(position) * 0.4, 4.);
	c = sqrt (c);
	gl_FragColor = vec4 (c, 1.);

}