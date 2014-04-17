#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main( void ) {

	
	vec2 cPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy+200.0;
	float cLength = cos(cPos.x*2.0)+sin(cPos.y)*2.0;
	
	vec2 uv =  gl_FragCoord.xy / resolution.xy + ( cPos / cLength ) * cos( cLength * 15. - time * 4.0 ) * .05;
	vec2 col =  uv;
	float colLength = length(col);
	gl_FragColor = vec4( colLength,colLength+20.0, 0.3, 0.2 );
	
}