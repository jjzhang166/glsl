#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 z = vec2(0,0);

void main( void ) {
	
	
 
	vec2 position = ( gl_FragCoord.xy / resolution.xy);

	//shader thingie by swyter -- move the mouse around, two words, bottom left
	//have fun, taleworlds! >:)
	gl_FragColor = vec4(
		            cos(sin(time/.8))/position.x/position.y,
		            sin(cos(time/.4))/position.x/position.y,
		            cos(sin(time/.2))/position.x/position.y, 1.0 )*(mouse.x*mouse.y);
}