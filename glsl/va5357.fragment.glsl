#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / cos(resolution.xy) );
	
	float r = cos(mod(time/200.,1.)*position.y)*2.;
	float g = sin(mod(time/200.,1.)*position.y)*2.;
	float b = tan(mod(time/200.,1.)*position.y)*2.;

	gl_FragColor = vec4( r, g, b, 1.) * asin(time);
}