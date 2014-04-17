#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// GLSL Shader tutorial by @hintz at OpenTechSchool Berlin 

void main( void ) 
{

	vec2 position = ( (gl_FragCoord.xy - mouse.xy*resolution)/ (resolution.xx + 0.5*resolution.xy));
	vec2 position2 = ( (gl_FragCoord.xy - 0.5*resolution)/ (resolution.xx + 0.5*resolution.xy)) ;
	
	float d = 100.0;
	float t = -time * 30.0;
	
	float b = sin(t+d*sqrt(position.x*position.x+position.y*position.y)+5.0*atan(position.y, position.x));
	b += sin(t+d*sqrt(position2.x*position2.x+position2.y*position2.y)-5.0*atan(position2.y, position2.x));
	float color = 0.0;
	gl_FragColor = vec4( vec3(b), 1.0 );

}