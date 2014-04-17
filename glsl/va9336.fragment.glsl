#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	gl_FragColor = vec4(abs(cos(position.x + 30.0 + time)), abs(cos(position.y * 30.0)),0.0,1.0);
	

}