#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.51;
	
	float len = length(position);
	float r = 0.45;
	len = smoothstep(r, r-0.0015, len);
	gl_FragColor = vec4(len, len, len, 1.0);

}