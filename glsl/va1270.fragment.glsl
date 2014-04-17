#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform int lineCount;

void main( void ) {

	vec2 position = gl_FragCoord.xy;

	float color = 0.0;
	
	if(position.x / 10.0 > 2.0) {
		color = 1.0;
	}
	

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}