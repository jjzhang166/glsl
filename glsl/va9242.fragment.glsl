#ifdef GL_ES
precision mediump float;
#endif

// another subpixel test

uniform vec2 resolution;
uniform float time;

float GetValue(vec2 spherePos, vec2 offset) {
	float radius = resolution.x * 0.1;
	return smoothstep(radius + 1.0, radius + 0.0, distance(gl_FragCoord.xy + offset, spherePos));
}

void main()
{
	vec2 spherepos = resolution.xy * 0.5 + vec2(1.0, 0.0) * 100.0 * cos(time * 0.3) + vec2(0.0, 1.0) * 10.0 * sin(time * 1.0);
	vec2 subpixel = vec2(1.0 / 3.0, 0.0);

	gl_FragColor.a = 1.0;
	gl_FragColor.r = GetValue(spherepos, -subpixel);
	gl_FragColor.g = GetValue(spherepos, vec2(0.0));
	gl_FragColor.b = GetValue(spherepos, +subpixel);
	
	if (gl_FragCoord.y < resolution.y * 0.5) {
		gl_FragColor.rgb = gl_FragColor.ggg;
	} else if (abs(gl_FragCoord.y - resolution.y * 0.5) < 1.0) {
		gl_FragColor.rgb = vec3(0.0);
	}

}

