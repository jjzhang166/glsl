#ifdef GL_ES
precision mediump float;
#endif

//penna
//playing around

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / -1.0;

	float color = 0.0;
	
	color += sqrt(position.x + position.y) - sqrt(mouse.x + mouse.y);
	vec3 finalpass = vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 );
	gl_FragColor = vec4( vec3( color, color , sin( color/ 3.0 ) * 0.75 ), 1.0 );

}