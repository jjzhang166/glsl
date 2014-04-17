#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 plane(vec3 ro, vec3 rd) {
	float t = dot(ro, vec3(0.0, 1.0, 0.0))/dot(rd, vec3(0.0, 1.0, 0.0));
	vec3 pos = ro + rd*t;
	if(rd.y < 0.0)
		return vec3(sin(pos.x) + sin(pos.z));
	return vec3(0.0);
}

vec3 intersect(vec3 ro, vec3 rd) {
	return plane(ro, rd);
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec3 ro = vec3(0.0, 30.0+sin(time)*5.0, 0.0);
	vec3 rd = normalize(vec3(2.0*uv-1.0, 1.0));
	
	gl_FragColor = vec4(0.0);
	gl_FragColor = vec4(intersect(ro, rd), 1.0);
}