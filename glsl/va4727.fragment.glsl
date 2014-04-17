#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy;

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec2 center = vec2(350.0, 200.0);
	vec2 f1 = center + vec2(0.0, -100.0);
	vec2 f2 = center + vec2(0.0, 100.0);
	

	if (length(position- f1) +  length(position- f2) < 245.0) {
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}
}