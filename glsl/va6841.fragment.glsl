#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = gl_FragCoord.xy/resolution.xy;
	float z = smoothstep(-1.0, 1.0, cos(time*5.0)*0.005);
	gl_FragColor = vec4(p.x, p.y, z, 0.5);
}