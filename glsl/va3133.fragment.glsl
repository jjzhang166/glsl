#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 screenPos = gl_FragCoord.xy / resolution;
	screenPos.x *= aspect;
	vec2 mousePos = mouse;
	mousePos.x *= aspect;

	gl_FragColor.r = smoothstep(0.2, 0.17, length(vec2(-0.25, -0.2) - surfacePosition));
	gl_FragColor.g = smoothstep(0.2, 0.17, length(vec2(0.45 * aspect, 0.3) - screenPos));
	gl_FragColor.b = smoothstep(0.2, 0.17, length(vec2(-0.20, 0.0) - surfacePosition));
	//gl_FragColor.b = smoothstep(0.2, 0.17, length(mousePos - screenPos));
	
	gl_FragColor.a = 1.0;

}