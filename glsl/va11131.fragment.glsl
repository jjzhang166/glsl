#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int STEPS = 30;

float box(vec3 r, vec3 p, vec3 b) {
	return length(max(abs(p-r)-b, 0.0));	
}

float ball(vec3 r, vec3 p, float s) {
	return distance(r,p)-s;	
}

float dist(vec3 r) {
	float dist;
	
	//dist = ball(r, vec3(sin(time)*5., 0, 10), 3.);
	dist = box(r, vec3(sin(time)*5.,0,10), vec3(2,2,2));
	return dist;
}

void main( void ) {

	vec2 coord = ( gl_FragCoord.xy / resolution.xy );
	coord.x *= resolution.x / resolution.y;

	vec3 crot = normalize(vec3(coord.x - (resolution.x / resolution.y)*0.5, coord.y - 0.5, 1.0));
	vec3 cpos = vec3(0,0,0);
	vec3 col = vec3(0,0,0);
	
	for (int i = 0 ; i < STEPS ; i++) {
		float d = dist(cpos);
		cpos = cpos + crot * d;
		
		if (d <= 0.01) {
			col.r = float(i) / float(STEPS);
			break;
		}
	}
	gl_FragColor = vec4(col, 1);
}