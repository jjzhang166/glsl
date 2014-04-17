
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int STEPS = 100;
const float ACCURACY = 0.01;
const float EPS = 0.005;
const float GA = 0.1;

float plane(vec3 r, float h) {
	return r.y-h;
}

float box(vec3 r, vec3 p, vec3 b) {
	return length(max(abs(p-r)-b, 0.0));	
}

float ball(vec3 r, vec3 p, float s) {
	return distance(r,p)-s;	
}

float dist(vec3 r) {
	float dist = 0.;
	dist = box(r, vec3(sin(time)*5.,1,10), vec3(1,2,2));
	dist = min(dist, plane(r, -0.03));
	
	return dist;
}

vec3 getN(vec3 p) {
	return normalize(vec3(
		dist(p + vec3(EPS,0,0)) - dist(p - vec3(EPS,0,0)),
		dist(p + vec3(0,EPS,0)) - dist(p - vec3(0,EPS,0)),
		dist(p + vec3(0,0,EPS)) - dist(p - vec3(0,0,EPS))
		));
}

void main( void ) {

	vec2 coord = ( gl_FragCoord.xy / resolution.xy );
	coord.x *= resolution.x / resolution.y;

	vec3 crot = normalize(vec3(coord.x - (resolution.x / resolution.y)*0.5, coord.y - 0.5, 1));
	vec3 cpos = vec3(0,0,0);
	vec3 col = vec3(0,0,0);
	vec3 n;
	vec3 ls = vec3(-3,2,2);
	float li;
	for (int i = 0 ; i < STEPS ; i++) {
		float d = dist(cpos);
		cpos = cpos + crot * d;
		
		if (d <= ACCURACY) {
			n = getN(cpos);
			ls = normalize(ls - cpos);
			li = dot(n, ls);
			col.r = GA + min(max(li,0.),1.);
			break;
		}
	}
	gl_FragColor = vec4(col, 1);
}