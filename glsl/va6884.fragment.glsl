#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = gl_FragCoord.xy/resolution.xy;
	p = 2.0*p - 1.0;
	float z = smoothstep(-0.5, 0.5, cos(time*5.0)*0.5);
	vec4 frag = vec4(abs(p.x), sin(cos(p.y) * 10.0 * time) * (1.0 - cos(p.y / p.x*200.0)), z, 1.0);
	frag += vec4( 0.3, 0.2, 0.1, 0.0);
	gl_FragColor = frag;
}