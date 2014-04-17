#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.14159265358979323846
 
   mat2 rotation = mat2( cos(M_PI/4.0)*(sin(time))*(0.9), sin(M_PI/.0)* cos(time)*(0.2),
                             -sin(M_PI/2.0), cos(M_PI/2.0)*tan(time));
void main( void ) {

	
	
	vec2 pos = mod(rotation * gl_FragCoord.xy, vec2(50.0)) - vec2(25.0);
	
	float dist_squared = dot(pos*(cos(time)), pos);
	
	gl_FragColor = mix(vec4(1.90, 1.90, 1.0, 1.0), vec4(0, .0, 1.40, 1.0),
			   smoothstep(480.0*(cos(time)), 320.25, dist_squared));

}