#ifdef GL_ES
precision mediump float;
#endif

// Mouse position tracking from http://glsl.heroku.com/e#3905.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float aspect = resolution.x / resolution.y;
	vec2 screenPos = gl_FragCoord.xy / resolution;
	screenPos.x *= aspect;
	
	float r = sin(screenPos.y);
	float g = sin(screenPos.x);
	float b = smoothstep(1.2, -1.2, length(mouse - screenPos));
	b = sin((b * 200.0));

	gl_FragColor.r = r;
	gl_FragColor.g = g;
	gl_FragColor.b = b;
	gl_FragColor.rgb =  1.0 - gl_FragColor.rgb;
	gl_FragColor.a = 1.0;

}