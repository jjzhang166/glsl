#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / sin(resolution.xy) );
	
	float r = cos(time*position.y)*2.;
	float g = sin(time*position.y)*2.;
	float b = tan(time*position.y)*2.;

	gl_FragColor = vec4( r, g, b, 1.) * atan(time);
}