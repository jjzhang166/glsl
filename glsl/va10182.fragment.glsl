#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323846
#define TWO_PI (PI*2.0)

#define M 5.0

float myColor(float arg) {
	float s = sign(arg - 0.5);
	float x = 2.0 * abs(arg - 0.5);
	x = sqrt(x);
	return 0.5 * x * s + 0.5;
}

// a,b in [0,1]
float softMin(float a, float b) {
	float al = a - 0.1;
	float ag = a + 0.1;
	float bl = b - 0.1;
	float bg = b + 0.1;
	float s = min(al,bl) + min(al,b) + min(al, bg)
		+ min(a,bl) + min(a,b) + min(a,bg)
		+ min(ag,bl) + min(ag,b) + min(ag,bg);
	return s / 9.0;
}

void main( void ) {

	vec2 realmouse = mouse + vec2(-0.5,-0.5);
	vec2 position = vec2(-0.5,-0.5) + ( gl_FragCoord.xy / resolution.xy );

	float ptime = mod(time * 15.0, TWO_PI);
	
	float color = 0.0;
	vec2 diff = position - realmouse;
	float angle = atan(diff.y, diff.x);
	float ddist = dot(diff.xy, diff.xy);
	for (float j = 0.0; j < M; j++) {
		vec2 p = vec2(0.4 * sin(time * 0.4214 + j * 4.4239), 0.4 * cos(time * 0.1237 + j * 5.437));
		vec2 pdiff = position - p;
		float tddist = dot(pdiff.xy, pdiff.xy);
		if (ddist > tddist) {
			angle = atan(pdiff.y, pdiff.x);
			ddist = tddist;
		}
		
	}
	float dist = 0.5 + 0.5 * sin(ddist * 37.0);
	float tcolor = 0.5 + 0.5 * sin(angle * 30.0 + sin(dist + 0.5*time) * 30.0 + time * 0.8);
	color = myColor(tcolor);
	
	gl_FragColor = vec4( vec3( color, color * 0.5 + 0.2 * sin(time * 0.71234 ), sin( color + time * 0.36432 ) * 0.75 ), 1.0 );
}