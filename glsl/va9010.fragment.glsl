#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float scene (vec3 pos) {
	return length (pos) - 0.5;
}
vec3 sceneNorm (vec3 pos) {
	float off = 0.01;
	vec3 tests = vec3 (
		scene (pos + vec3 (off, 0., 0.)),
		scene (pos + vec3 (0., off, 0.)),
		scene (pos + vec3 (0., 0., off))
	);
	tests -= pos;
	return normalize (tests);
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy * 2. - 1.;
	position.x *= resolution.x / resolution.y;
	vec3 c = vec3 (0.);
	
	vec3 camPos = vec3 (mouse, -2.);
	vec3 camTarget = vec3 (0.);
	vec3 camLook = normalize(camTarget - camPos);
	
	vec3 camUp = vec3 (0., 1., 0.);
	vec3 camRight = cross (camLook, camUp);
	camUp = cross (camRight, camLook);
	camUp = normalize (camUp);
	camRight = normalize (camRight);
	vec3 ptLook = normalize (camLook + position.y * camUp + position.x * camRight);
	
	bool hit = false;
	for (int steps = 0; steps < 10; steps++) {
		if (hit) continue;
		float dist = scene (camPos);
		if (dist < 0.01) {
			hit = true;
			vec3 normal = sceneNorm (camPos);
			vec3 light = normalize (vec3 (0.1, -1., 0.5));
			c = vec3 (dot (normal, light));
		}
		camPos += ptLook * dist;
	}
	
	gl_FragColor = vec4 (c, 1.);
}