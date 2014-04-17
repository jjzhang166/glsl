#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float lengthx (vec3 p, float x) {
	return pow(
		pow (abs(p.x), x) + 
		pow (abs(p.y), x) + 
		pow (abs(p.z), x),
	1./x);
}

float scene (vec3 p) {
	return lengthx (p, sin (time)*2. + 4.) - 0.5;
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
	
	vec3 camPos = vec3 ((mouse.x-0.5)*3., (mouse.y-0.5)*3., -1.);
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
			c += lig * vec3(1., 0.9, 0.5);
			vec3 l2 = normalize(vec3(0.2, 1., 0.));
			float lig2 = max (0., dot (l2, n));
			c += lig2 * vec3 (0.3, 0.4, 1.)* 0.3;
			c += vec3(1.) *pow(max(0., dot (n, cd) + 1.), 8.);
		} else {
			cp += cd * d;
		}
	}
	c = sqrt (c);
	gl_FragColor = vec4(c, 1.0 );

}