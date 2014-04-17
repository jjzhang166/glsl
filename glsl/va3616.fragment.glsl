#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 bgColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	vec4 layerColor = vec4( 0.0, 0.0, 0.0, 1.0 );
	
	vec4 startColor = vec4( 1.0, 0.0, 0.0, 0.0 );
	vec4 endColor = vec4( 0.0, 0.0, 0.0, 0.0 );
	
	float len = 0.7;
	
	if( position.y <= mouse.y ){
		
		float start = mouse.y;
  		float end = position.y + len;
  		float d = 1.0 - ( (start - position.y) / (end - start) );
		
		layerColor = mix( endColor, startColor, d );
		
	}

	gl_FragColor = mix( bgColor, layerColor, 0.5 );

}