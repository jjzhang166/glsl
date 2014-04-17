#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	
	float color = 0.0;
	color += sin(position.x / (tan(position.y)));

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 );

}