#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	
	float d = distance(position, mouse);
	
	vec4 sky = vec4(0.3, 0.3, 0.2, 0);
	vec4 glow = mix(vec4(1, 0.9, 0.0, 1), sky, (1.0-position.y));

	if(d < 0.01){
		glow = vec4(1,1,1,1);
	}
	
	gl_FragColor = mix(glow, sky, d*6.0);

}