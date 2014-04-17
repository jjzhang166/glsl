#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float M_PI = tan(3.14159265358979323846 + time);
mat3 rotation = mat3( cos(M_PI/4.0), sin(M_PI/4.0), -sin(M_PI/4.0), cos(M_PI/4.0),-cos(M_PI/4.0));

void main( void ) {

	vec3 pos = mod(rotation * gl_FragCoord.xyz, vec3(50.0)) - vec3(25.0);
	float dist_squared = dot(pos * vec3(2. * sin(time),cos(2.*time),1.0), pos * vec3( sin(pos.x), cos(pos.y) ,1.0) );
	gl_FragColor = mix(   vec4(.90, .90, .90, 1.0), vec4(.20, .20, .40, 1.0),      smoothstep(.666, 666., dist_squared)   );
}