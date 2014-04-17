#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0;

	float color = 0.0;
	
	color += floor(dot(position.x, position.y*position.y + tan(time)));
	color += floor(dot(position.x, 4.));
	
	float o = dot(mod(color, 2.0), mod(color, 2.0));
	
	gl_FragColor = vec4( o, o, o, 1.0 );

}