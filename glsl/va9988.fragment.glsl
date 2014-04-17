#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;

	float color = 0.0;
	if(position==resolution.xy)
		color=1.0;
	gl_FragColor = vec4( color,color,color, 1.0 );

}