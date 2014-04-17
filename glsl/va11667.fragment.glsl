#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float rand;
	
	rand= time;

	vec4 color = vec4(vec2(floor(sin(position.x/30.0*rand+rand*rand))*30.0*rand,0),vec2(floor(sin(position.y/30.0*rand+rand*rand))*30.0*rand,0));
	
	gl_FragColor = color;

}