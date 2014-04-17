#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	p.x *= 1.666;
	p *= 5.0;
	float lp = length(p);
	vec3 h = vec3(sin(lp * 10.0) * 0.5 + 0.5, 0.0, 0.0);
	h += vec3(0.0, sin(lp * 20.0 + time - 0.8) * 0.5 + 0.5, 0.0);
	h += vec3(0.0, 0.0, sin(lp * 40.0 + time * 2.0 + 0.5) * 0.5 + 0.5);

	gl_FragColor = vec4(h, 1.0);
	
}