// Modified to follow mouse

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;

void main( void ) {
		gl_FragColor = vec4(fract(sin(dot(gl_FragCoord.xy * time ,vec2(12.9898,78.233))) * 43758.5453) / 11. + .9);
	}