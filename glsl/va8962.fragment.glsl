#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float color = mouse.x * mouse.y;
	if (position.x > 0.8 || position.x < -0.8)
	{
	   color = 0.0;   	
	}
	gl_FragColor = vec4(color, color, 1.0, 1.0);
}