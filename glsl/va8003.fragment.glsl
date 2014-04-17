#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	float v = ( pos.x + pos.y * time );
	gl_FragColor = vec4(v, v, v, 1.0);
}