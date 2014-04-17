#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float color = 0.0;
	vec2 mouseDelta = gl_FragCoord.xy - mouse / resolution;
	if (mouseDelta.x > 0.0) color = 1.0;
	gl_FragColor = vec4(mouse.x / resolution.x, 0.0, 0.0, 1.0);
}