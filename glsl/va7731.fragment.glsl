#ifdef GL_ES
precision mediump float;
#endif


//@mattdesl

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy);

	float r = clamp(time, 0.9, 1.0);

	
	vec3 color = vec3(r);

	gl_FragColor = vec4( color, 1.0);
}