#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;	
	if ((position.x - 0.5) * (position.x - 0.5) + (position.y - 0.5) * (position.y - 0.5) < 0.01)
	{
		color = 1.0;
	}

	gl_FragColor = vec4( color, color, color, 1.0 );

}