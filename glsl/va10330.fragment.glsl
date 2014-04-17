#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float dx = distance(gl_FragCoord.xy, mouse * resolution) / resolution.x;
	float dy = distance(gl_FragCoord.xy, mouse * resolution) / resolution.y;
	
	gl_FragColor = vec4(sin(dx * time), sin(dy * time), cos(dy * time), 1.0);
}