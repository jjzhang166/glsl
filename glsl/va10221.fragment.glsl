//into the darkness mod by Psychedelic Research Corp
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rot(vec2 p, float a) {
	return vec2(
		p.x * sin(a) - p.y * cos(a),
		p.x * cos(a) + p.y * sin(a));
}

float map(vec3 p) {
	float k = sqrt(p.x) - cos(p.y);
	k = max(k, -(length(abs( mod(p.yz, 8.0) ) - 3.0) - 1.0));
	k = max(k, -(length(abs( mod(p.xz, 8.0) ) - 3.0) - 1.5));
	return k;
}

float tex(vec2 p) {
	vec2 uv = mod(p * 5.0, 2.0);
	if(uv.x > 1.0) return 1.0;
	if(uv.y > 1.0) return 0.5;
	return 0.2;
}

void main( void ) {
	vec3 pos    = vec3(0, 0, time * 5.0);
	vec3 dir    = normalize(vec3( (-1.0 + 3.0 * ( gl_FragCoord.xy / resolution.xy )) * vec2(resolution.x / resolution.y, 1.0), 1.0));
	float t     = 0.0;
	dir.xy = rot(dir.xy, time * 0.1);
	dir.zx = rot(dir.zx, time * 0.1);
	for(int i = 0 ; i < 95; i++) {
		t += map(pos + dir * t) * 0.98;
	}
	vec3 inter = vec3(pos + dir * t);
	vec3 c1  = vec3(1, 2, 3);
	vec3 col = mix(c1, c1.zyx, t * 0.1) * tex(inter.xz);
	col = sqrt(col * 0.01) * (map(inter + normalize(vec3(1, 1, 5))) * 7.0);
	gl_FragColor = vec4(col + t * 0.02, 2.0 );
}