//Set to 0.5 /\

// by davedes
// simple circle outline, not the best technique...  -> THERE IS ONE! Look :D -Chaeris
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main(void) {
	
	vec2 position = (gl_FragCoord.xy - resolution.xy * 0.5) / length(resolution.xy) * 400.0;
	vec3 color;
	
	if( length(position.xy) < 88.9  && length(position.xy) > 88.5) 
		color = vec3(0.4, 0.7, 0.5);
	
gl_FragColor = vec4(color, 1.0); } 
//Edited by Chaeris, much simpler, right ?
//This technique has nearly the same quality in 0.5 mode... 
//But also looks terrible at lower precisions!