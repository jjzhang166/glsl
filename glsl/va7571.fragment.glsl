#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
 
	vec2 position = ( gl_FragCoord.xy / resolution.xy);

	//shader thingie by swyter -- move the mouse around, two words, bottom left
	//have fun, taleworlds! >:)
	gl_FragColor = vec4(.2)*position.x/position.y*position.x*position.x*position.x*position.x;
	gl_FragColor.b += 0.18;
}