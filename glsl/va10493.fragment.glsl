#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 8.0;

	float color = 0.0;
	color = sin(position.y * time * 88.0) * cos(position.x *time*88.0); 
	color = color * color * color *color * color;
	gl_FragColor = vec4( 0.5+ position.x*.5, color, color, 1.0 );

}