#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

float noisy(float x, float y) {
	// poofy fractal-noise(ish) clouds
	float val = 0.5;
	for (float i=0.0; i<10.0; i++) {
		float ang = pow((i + 2.53) * 7.15, 2.5);
		float scale = 4.0 + i * i * 0.3;
		val += sin((x - i * 15.0) * sin(ang) * scale - (y + i * 10.0) * cos(ang) * scale) / (i + 3.0);
	}
	return clamp(val, 0.0, 1.0);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;

	// color defaults
	vec3 fog = vec3(0.8, 0.3 + 0.4 * pow(position.y, 0.1), 0.3 + 0.3 * pow(position.y, 0.2));
	vec3 contrail = vec3(0.9, 0.88, 0.85);
	vec4 me = vec4(0.8 - 0.2 * position.y, 0.7, 0.9, 1.0);

	// draw clouds using noisy() function
	float clouds = noisy(position.x + time * 0.01, position.y * resolution.y / resolution.x * 3.0);
	me.rgb = me.rgb * (1.0 - clouds) + fog * clouds;

	if (position.y > 0.5) {
		float plane = mod(time * 0.2, 37.0) + 3.6;                                                   // Z position of plane
		vec3 planespace = vec3(-5.0 + plane * 0.7, 2.0, plane);                                      // Plane coordinates in 3D space
		vec2 planepos = vec2(0.5 + planespace.x / planespace.z, 0.5 + planespace.y / planespace.z);  // Screen coordinates of plane
		float planesize = 0.002 / planespace.z;                                                      // Scaled size of plane flare

		float contrail_z = 2.0 / (position.y - 0.5);                       // what the variable "plane" would be at this point in the contrail
		float contrail_x = 0.5 + (-5.0 + contrail_z * 0.7) / contrail_z;   // where the center X would lie at this point in the contrail
		float diff = 1.0 - ((plane - contrail_z) / 20.0);                  // Z distance between plane and this point in the contrail
		if ((diff > 1.0) || (diff < 0.0)) {diff = 0.0;}
		float contrail_w = (1.2 - diff) - abs(position.x - contrail_x) * 3.0 * contrail_z;   // contrail width at this point
		float contrail_alpha = clamp(diff * diff * contrail_w, 0.0, 1.0) * (1.0 - clouds);   // final alpha value for contrail

		me.rgb = me.rgb * (1.0 - contrail_alpha) + contrail * contrail_alpha;  // draw contrail
		me.rgb += (1.0 - clouds) / length(position - planepos) * planesize;    // draw plane
	}

	me.a = 1.0;
	gl_FragColor = me;
}

