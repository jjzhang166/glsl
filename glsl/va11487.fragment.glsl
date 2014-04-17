#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	//float dist = distance(mouse * resolution.xy, gl_FragCoord.xy) / 64.0;
	float dist = distance(vec2(0.5, 0.5)* resolution.xy, gl_FragCoord.xy) / 64.0;
	float r = 1.0 / dist;
	float g = 1.0 / dist;
	float b = 1.0 / dist;
	gl_FragColor = vec4(r, g, b, 1.0);
}