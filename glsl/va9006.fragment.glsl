#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	float color = 0.0;
	color += sin((position.x + time/10.0) * 20.0);
	color *= sin(position.x - position.y * (time / 10.0) );
	color += sin(position.x * 10.0 * time/150.0);
	color += cos((position.y + time/10.0) * 20.0);
	
	color *= ((1.0 + cos(time)) / 8.0) + 0.5;

	gl_FragColor = vec4( color/2.0, color/2.0, 1.0, 1.0 );

}