#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = ( gl_FragCoord.xy * mouse.xy / resolution.xy );
	float x = position.x;
	float y = position.y;
	
	float r = 0.0;
	float g = y * x;
	float b = 0.0;
	gl_FragColor = vec4( vec3( r, g, b ), 1.0 );

}