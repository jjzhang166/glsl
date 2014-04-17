#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {

	
	vec2 cPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	float cLength = length(cPos);
	
	vec2 uv =  gl_FragCoord.xy / resolution.xy + ( cPos / cLength ) * cos( cLength * 15. - time * 4.0 ) * .05;
	vec2 col =  uv;

	gl_FragColor = vec4( col, .3, 1.0 );
	
}