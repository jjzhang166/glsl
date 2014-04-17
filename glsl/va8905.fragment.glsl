#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float scene (vec3 p) {
	return length (p) - 0.5;
}

vec3 norm (vec3 p) {
	float off = 0.1;
	vec3 checks = vec3 (
		scene (p + vec3 (off, 0., 0.)),
		scene (p + vec3 (0., off, 0.)),
		scene (p + vec3 (0., 0., off))
	);
	checks -= scene (p);
	return normalize (checks);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;
	position.x *= resolution.x / resolution.y;
	vec3 c = vec3(1.);
	
	vec3 camPos = vec3 (0., 0., -1.);
	vec3 camTarget = vec3 (0.);
	vec3 camLook = camTarget - camPos;
	vec3 camUp = vec3 (0., 1., 0.);
	vec3 camRight = cross (camUp, camLook);
	camUp = cross (camRight, camLook);
	camRight = normalize (camRight);
	camUp = normalize (camUp);
	
	vec3 cp = camPos;
	vec3 cd = normalize (camLook + camUp *position.y + camRight * position.x);
	bool hit = false;
	for (int i = 0; i < 20; i++) {
		if (hit) continue;
		float d = scene (cp);
		if (d < 0.01) {
			vec3 n = norm (cp);
			vec3 l = vec3 (0.4, -1., -0.5);
			l = normalize (l);
			float lig = max(0., dot (l, n));
			c = vec3 (0., 0., 0.05);
			c += lig * vec3(1.);
		} else {
			cp += cd * d;
		}
	}
	c = sqrt (c);
	gl_FragColor = vec4(c, 1.0 );

}