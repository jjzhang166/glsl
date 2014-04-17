#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += cos(sin(distance(position, mouse)*(100.0+abs(sin(time))*100.0)));
	color *= 0.5;

	gl_FragColor = vec4( vec3( color ), 1.0 );

}