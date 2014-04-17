#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = (gl_FragCoord.xy - (resolution * 0.5)) / min(resolution.y,resolution.x) * 2.0 ;
	float number = 0.5 * time;
	number += 0.1;
	float red = 0.1 * number  / time;
	
       
	
	gl_FragColor = vec4(0, 0.5 * time,0, 0.5 / time);
}