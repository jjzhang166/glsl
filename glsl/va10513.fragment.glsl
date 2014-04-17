#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// GLSL Shader tutorial by @hintz at OpenTechSchool Berlin 

void main(void) 
{

	vec2 position = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.x; 
	vec2 position2 = position - mouse + 0.5;
	
	float b = sin(100.0*length(position));
	b += sin(100.0*length(position2));
	
	gl_FragColor = vec4(b, b, b, 1.0);

}