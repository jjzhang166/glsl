#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.141592653589793;

void main( void ) {
	vec2 pos = (gl_FragCoord.xy / resolution.xy) - vec2(0.5, 0.5);
	if (length(abs(sin(pos*2.6*time))) > 0.2222) discard;
	
	vec3 norm = normalize(
		vec3(pos.x, pos.y, sqrt(0.25 - pos.x*pos.x - pos.y*pos.y))
	);
	
	gl_FragColor = vec4(
		(1.0 + norm.x)/5.0,
		(1.0 + norm.y)/2.0,
		(1.0 + norm.z)/2.0,
		1.0
	);
}