#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	
	float color = 0.0;
	
	if (position.x >= resolution.x / 2.0)
		position.x = 1.0;
	else	
		position.x = 0.0;
	
	if (position.y <= resolution.y / 2.0)
		position.y = 1.0;
	else
		position.y = sin(time);
	
	color += position.x;
	color += position.y;
	
	
	gl_FragColor = vec4(color, color, color, 1.0 );

}