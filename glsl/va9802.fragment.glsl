#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float thickness = 0.6, spacing = 9.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	float test = (gl_FragCoord.x+gl_FragCoord.y)/spacing+sin(gl_FragCoord.x*0.2+time)
		+cos(gl_FragCoord.y*0.2+time);
	
	
	float color = 0.0;
	if (test-floor(test) < thickness) color = 0.5;

	gl_FragColor = vec4( 0.0,color,0.0, 1.0 );

}