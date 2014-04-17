#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float thing(vec3 p) {
	float f = length(p) - 2.0;
	float d =  max(f, length(p.xz) - 0.5);
	d = min(d, max(f, length(p.xy) - 0.5));
	d = min(d, max(f, length(p.zy) - 0.5));
	d = min(max(-f - 0.5, d), max(-d, f + 1.0));
	vec4 fp = abs(vec4(d - 0.25, p));
	const float r = 0.2;
	d = min(d, (length(fp.xy) - r));
	d = min(d, (length(fp.xz) - r));
	d = min(d, (length(fp.xw) - r));
	return d;
}

void main( void ) {
	vec2 position = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution );
	vec3 world = vec3(position.x, mouse.x * 2.0 - 1.0, position.y);
	world.x *= resolution.x / resolution.y;
	world *= 3.0;

	float dist = thing(world);

	if (dist < 0.0) {
		gl_FragColor.rgb = vec3(abs(dist), 0, 0);
	} else {
		gl_FragColor.rgb = vec3(0, dist, 0);	
	}
	
	gl_FragColor = vec4(smoothstep(0.1, 0.11, -dist));
}