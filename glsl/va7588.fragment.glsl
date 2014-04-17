#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 pink = vec3(224./255.,77./255.,251./255.);
	vec3 blue = vec3(111./255.,216./255.,235./255.);
	vec3 green = vec3(122./255.,214./255.,61./255.);
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );


	gl_FragColor = vec4( vec3(pink*blue*green*vec3(length(mouse),position.x,abs(sin(time))))*3., 1.0 );

}