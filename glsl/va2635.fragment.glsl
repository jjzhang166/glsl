#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f(vec2 x) {
	float r = length(x), a = atan(x.y, x.x);
	return r-1. + 0.5*tan(6.*a+2.*(1./2. * r)*r*tan(sin(time / 4.)));
}

vec2 grad(vec2 p) {
	vec2 h = vec2(0.01, 0.);
	return vec2(f(p+h.xy) - f(p-h.xy), f(p+h.yx) - f(p-h.yx))/(2.0*h.x);
}

float color(vec2 x) {
	float v = f(x);
	vec2 g = grad(x);
	float de = g.x ;
	float blah = 0.05;
	return smoothstep(blah*0.9, blah, de);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy * 2. - 1.;
	position *= 2.0;

	float v = color(position);
	float v2 = color(sin(position));
	gl_FragColor = vec4( 0, 0, v2, 1.0 );

}