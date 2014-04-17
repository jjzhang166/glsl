#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand( vec2 n ) {

	  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.4453*sin(time));
}

void main( void ) {

	vec4 color;
	color.rgb += rand( 0.1 * gl_FragCoord.xy ) / 4.0;	
	gl_FragColor = vec4( color.xyz, 1.0 );

}