//Set to 0.5 /\

// by davedes
// simple circle outline, not the best technique...  -> THERE IS ONE! Look :D -Chaeris
// ROQUEN: Quick hack
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

#define RADIUS 88.0

void main(void) {
	
	vec2 position = (gl_FragCoord.xy - resolution.xy * 0.5) / length(resolution.xy) * 400.0;
	vec3 color;
	
	float s =  1.0-smoothstep(0.1, 0.35, abs(length(position)-RADIUS));

	color = s*vec3(0.4, 0.4, 0.5);
	
gl_FragColor = vec4(color, 1.0); } 
//Edited by Chaeris, much simpler, right ?
//This technique has nearly the same quality in 0.5 mode... 
//But also looks terrible at lower precisions!