#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = (gl_FragCoord.xy - (resolution * 0.5)) / min(resolution.y,resolution.x) * 2.0;
	
	float f = length(pos);
	float red = smoothstep(f, f+.025, mod(time * 0.1, 1.0));
	
	gl_FragColor = vec4(red, 0.0, 0.0, 1);
}