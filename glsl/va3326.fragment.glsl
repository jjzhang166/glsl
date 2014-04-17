#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	float epsilon = 0.01;
	gl_FragColor = (min(uv.x, uv.y) < 0.01 || max(uv.x, uv.y) > 1.0-epsilon) ? vec4(0.0, 0.0, 0.0, 1.0) : vec4(1.0, 1.0, 1.0, 1.0);

}