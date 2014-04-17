//idk lol
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWOPI 6.28318

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 col= vec3( 
		cos(pos[0] * pos[1] * TWOPI) *239. ,
		cos(pos[0] * pos[1] * TWOPI) *84. ,
		cos(pos[0] * pos[1] * TWOPI /cos(time*TWOPI*.2)) *56.
	) /255.;
	vec3 col2 = vec3(49., 44., 38.)/255.;	
	
	gl_FragColor = vec4(
		max(
			tan(time)*col, col2
		), 
	1);

}