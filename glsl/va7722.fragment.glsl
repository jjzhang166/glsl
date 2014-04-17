#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;

	float times = 1.0;
	
	float p = smoothstep(0.0, 0.99, 1.0-pow(length(position.xy), 2.0)) * 3.5;
	vec4 color = vec4(0.3, 0.4, 1.0, 1.0);
	
	gl_FragColor = color * vec4(p, p, p, 1.0);
}