#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float color = 0.0;
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	color += position.x;
	gl_FragColor=vec4(color,color,1.0,1.0);
}