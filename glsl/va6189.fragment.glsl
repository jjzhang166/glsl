#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.14159265358979323846
varying vec2 uv;

void main( void ) {

	 vec2 pos = mod(gl_FragCoord.xy, vec2(50.0)) - vec2(25.0);
	gl_FragColor = mix(vec4(.90, .90, .90, 1.0), vec4(.20, .20, .40, 1.0), smoothstep(380.25, 420.25, dot(pos, pos)));	
}