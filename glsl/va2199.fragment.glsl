#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	
	color += smoothstep(position.x, position.y, cos(time+position.y))*mod(sin(time)*time, dot(position.x,position.y));
	color += smoothstep(position.y, position.x, sin(time+position.x))*mod(cos(time)*time, dot(position.y,position.x));
	
	gl_FragColor = vec4( color, 0.0, 0.0, 1.0 );

}