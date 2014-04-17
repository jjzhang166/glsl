#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * cos(time);
	vec3 color = vec3(position,1.0);
	gl_FragColor = vec4(color,1.0);
}