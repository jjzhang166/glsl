#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 cartToPolar(vec2 cart)
{
	return vec2(sqrt(cart.x * cart.x + cart.y * cart.y), atan(cart.y, cart.x));
}

void main()
{
	vec2 polar = cartToPolar(-1.0 + 2.0 * gl_FragCoord.xy);
	gl_FragColor = vec4(polar.y, polar.x, 1.0, 1.0);
}