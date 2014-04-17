// Mouse Circle by Jonny D

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color = 1.0 - pow(distance(gl_FragCoord.xy, mouse * resolution) / resolution.x - 0.04, 0.2);

	gl_FragColor = vec4( vec3( color, color, color ), 1.0 - color );

}