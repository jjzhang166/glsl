#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// my variables --------------------

const float PI = 3.14159265;
const float MAX_ITERATIONS = 100.0;
const float ANGLE = PI/4.;

float sinA = sin(ANGLE);
float cosA = cos(ANGLE);
float side = 0.2;
float f = -1.;
vec3 color = vec3( .0, .0, .0);

//----------------------------------

void showCircle( vec2 p) {
	if( length(p) < .5) {
		color.z =  1.0;
	}
}

bool insideTriangle(vec3 p, vec3 v0, vec3 v1, vec3 v2) {
	v0 -= p, v1 -= p, v2 -= p;
	vec3 u = cross(v1, v2);
	vec3 v = cross(v2, v0);
	vec3 w = cross(v0, v1);
	
	return dot(u, v) >= 0.0 && dot(u, w) >= 0.0;
}

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p.x *= aspect;
	vec3 v0 = vec3(0.5*aspect, .8, 1.0);
	vec3 v1 = v0 + vec3(-side*cosA, -side*sinA, 0.0);
	vec3 v2 = v1 + vec3(2.0 * (v0.x - v1.x), 0.0, 0.0);
	
	showCircle(vec2(v0.x, v0.y));
	showCircle(vec2(v1.x, v1.y));
	showCircle(vec2(v2.x, v2.y));
	
	for(float i = 0.; i < MAX_ITERATIONS; i++) {
		if(insideTriangle(vec3(p, 1.0), v0, v1, v2)) {
			color.x = 1.0;
		}
	/*
		//f *= -1.;
		side = length(v0 - v2);
		v0 = v2;
		v1 = v2 + vec3(f*side*cosA, f*side*sinA, 0.0);
		v2 = v1 + vec3(2.0 * (v0.x - v1.x), 0.0, 0.0);
	*/
	}
	
	gl_FragColor = vec4( color, 1.0 );

}