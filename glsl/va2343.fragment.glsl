#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (gl_FragCoord.xy);

	float color = abs(sin(time+(gl_FragCoord.y*gl_FragCoord.x)));
	gl_FragColor = vec4( vec3( color, color , color ), 1.0 );

}