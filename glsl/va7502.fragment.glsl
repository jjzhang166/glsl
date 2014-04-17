#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 z = vec2(0,0);

void main( void ) {
 
	vec2 position = ( gl_FragCoord.xy / resolution.xy);

	gl_FragColor = vec4(
		            sin(time/2.)<=0. ? sin(-time/2.)*gl_FragCoord.y/resolution.y : sin(time/2.)*gl_FragCoord.x/resolution.x,
			    abs(sin(time/2.))*(gl_FragCoord.y/resolution.y+gl_FragCoord.x/resolution.x)/2.,
			    sin(time/2.)>=0. ?sin(time/2.)*gl_FragCoord.y/resolution.y : sin(-time/2.)*gl_FragCoord.x/resolution.x  ,
			    1.0 );
}