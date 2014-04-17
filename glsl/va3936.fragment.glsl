#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14;
float pi2 = 6.28;

void main( void ) {

	vec3 pos = vec3((2.*( gl_FragCoord.xy -resolution.xy*0.5 )/ resolution.y )+mouse , mouse / 4.0);
	vec3 color = vec3(gl_FragCoord.x - mouse.x, gl_FragCoord.y - mouse.y, gl_FragCoord.x - gl_FragCoord.y);
	gl_FragColor = vec4( color, 1.0 );

}