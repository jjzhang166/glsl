#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 pos = gl_FragCoord.xy / resolution;

	gl_FragColor.r = smoothstep(0.2, 0.17, length(vec2(0.3, 0.3) - pos));
	gl_FragColor.g = smoothstep(0.2, 0.17, length(vec2(0.45, 0.3) - pos));
	gl_FragColor.b = smoothstep(0.2, 0.17, length(mouse - pos));

	gl_FragColor.a = 1.0;

}