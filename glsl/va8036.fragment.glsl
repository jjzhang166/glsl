#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 texcoord    = ( gl_FragCoord.xy / resolution );
	vec3 color       = vec3( texcoord.x, texcoord.y, 0.0 );

	gl_FragColor.rgb = color;
}