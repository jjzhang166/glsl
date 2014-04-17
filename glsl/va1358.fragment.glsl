#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float M_PI = 3.14159265358979323846;
mat2 rotation = mat2( cos(M_PI/4.0), sin(M_PI/4.0), -sin(M_PI/4.0), cos(M_PI/4.0));

void main( void ) {

	vec2 pos = mod(rotation * gl_FragCoord.xy, vec2(50.0)) - vec2(25.0);
	float dist_squared = dot(pos * vec2(2. * sin(time),cos(2.*time)), pos * vec2( sin(pos.x), cos(pos.y) ) );
	gl_FragColor = mix(   vec4(.90, .90, .90, 1.0), vec4(.20, .20, .40, 1.0),      smoothstep(.666, 666., dist_squared)   );
}