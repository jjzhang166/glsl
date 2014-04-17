#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdSphere(vec3 p, float s) {
  return length(p)-s;
}

float sdBox(vec3 p, vec3 b) {
  vec3 d = abs(p) - b;
  return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

vec3 map(in vec3 p) {
  float d = sdSphere(p, 0.2);
  return vec3(d, 0.0, 0.0);
}

vec3 intersect(in vec3 ro, in vec3 rd) {
  float t = 0.0;
  for (int i = 0; i < 10; i++) {
    vec3 h = map(ro + rd*t);
    if ( h.x<0.001 ) {
      return vec3(t,h.yz);
    }
    t += h.x;
  }
  return vec3(-1.0);
}

void main( void ) {

	vec2 p = (-resolution + 2.0*gl_FragCoord.xy) / resolution.y;
	vec3 ro = vec3(0.0, 0.0, 2.0);
	vec3 rd = vec3(p, 0.0) - ro;
	rd = normalize(rd);
	vec3 i = intersect(ro, rd);
	if (i.x > 0.0) {
		gl_FragColor = vec4(1.0);
	} else {
		gl_FragColor = vec4(p.x, p.y, 0.0, 1.0);
	}
	
	
	
}