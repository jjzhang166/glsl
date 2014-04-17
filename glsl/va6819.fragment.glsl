#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy;

	float color = 0.0;
	color += sin(p.y+time*5.0);

	gl_FragColor = vec4( vec3( color, color, color), 1.0 );

}