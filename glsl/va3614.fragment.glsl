#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 color = vec4( 0.0, 0.0, 0.0, 1.0 );
	
	vec4 startColor = vec4( 1.0, 0.0, 0.0, 1.0 );
	vec4 endColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	
	float len = 0.4;
	
	if( position.y <= mouse.y ){
		
		float start = mouse.y;
  		float end = position.y + len;
  		float d = 1.0 - ( (mouse.y - position.y) / (end - start) );
		
		color = mix( startColor, endColor, d );
		
	}
	

	gl_FragColor = color;

}