#ifdef GL_ES
precision mediump float;
#endif

// acs - simple catmull rom spline example

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 catmullRomSpline( vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t){
	return 	0.5 * (
			(2.0 * p1) +
			(-p0 + p2) * t +
			(2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * pow(t, 2.0) +
			(-p0 + 3.0 * p1 - 3.0 * p2 + p3) * pow(t, 3.0)
		);
}

void main( void ) {
	vec3 p0 = vec3(1.0, 0.0, 0.0); //Red
	vec3 p1 = vec3(0.0, 1.0, 0.0); //Green
	vec3 p2 = vec3(0.0, 0.0, 1.0); //Blue
	vec3 p3 = vec3(1.0, 1.0, 1.0); //White
	vec3 p4 = vec3(0.5, 0.5, 0.5); //Gray
	vec3 p5 = vec3(0.0, 0.0, 0.0); //Black
	
	
	float t = gl_FragCoord.s / resolution.x;
	
	
	vec3 c = catmullRomSpline(p0, p1, p2, p3, t); 
				
	gl_FragColor = vec4(c, 1.0);
}

