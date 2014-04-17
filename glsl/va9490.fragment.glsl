#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 color( vec2 p ) {
	float d = length(p);
	float a = atan(p.y, p.x);
	return vec3(mod(1.0*(1.0+cos(time))/d, 0.2), 0.2*(1.0+cos(a+time)), 0.0);
}

void main( void ) {
	vec2 p = -1.0+2.0*gl_FragCoord.xy/resolution.xy;
	gl_FragColor = vec4(color(p), 1.0);
}