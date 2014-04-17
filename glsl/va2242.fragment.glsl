#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 32.0;

	float color = 0.0;
	
	color = dot(sin(1000.0*position.x), cos(1000.0*position.y));
	color += smoothstep(color-0.125, color+1.0, color*50000.0);
	
	gl_FragColor = vec4( color, color, color, 1.0 );

}