#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// @josep_llodra

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float b,g,r = 0.0;
	
	b = abs(cos(time + position.x));
	g = abs(sin(time + position.y));
	r = abs(tan(time + position.x/position.y));

	gl_FragColor = vec4( vec3( r, g, b ), 1.0 );

}