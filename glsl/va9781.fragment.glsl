#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float dist = distance(position,gl_FragCoord.xy);
	float color = 0.0;
	if (dist < 50.0) color = 1.0;

	gl_FragColor = vec4(color, color, color, 1.0 );

}