#ifdef GL_ES
precision mediump float;
#endif


//@mattdesl

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//const vec3 BLUE = vec3(64.0/255.0, 90.0/255.0, 118.0/255.0);
const vec3 BLUE = vec3(29.0/255.0, 37.0/255.0, 49.0/255.0);

void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	
	float c = length(position - 0.5);
	float len = length(position*3.0);
	float r = sin(gl_FragCoord.y*0.045 * (sin(len*1.2 + (time*0.015))/2.0) + time*0.1)*300.0;
	r = clamp(r, 0.8, 1.5);
	
	float vignette = clamp(smoothstep(0.95, 0.9, c), 0.0, 1.0);
	
	vec3 color = vec3(r) * BLUE * vignette;
	
	gl_FragColor = vec4( color, 1.0);
}