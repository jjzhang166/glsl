#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = gl_FragCoord.xy/resolution.xy;
	
	float a = p.x;
	
	float b = smoothstep(0., 0.23, a) - smoothstep(0.23, 0.56, a);
	float g = smoothstep(0., 0.56, a) - smoothstep(0.56, 0.99, a);
	float r = smoothstep(0., 0.99, a);
	
	
	gl_FragColor = vec4(r, g, b, 1.0);
}