#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 lerp(vec2 a, vec2 b, float v) {
	return a + (b - a) * v;
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	pos = lerp(vec2(sqrt(dot(pos, pos)), atan(pos.y, pos.x)), pos, abs(sin(time/5.0)));
	float color = (mod(pos.x, 0.1) < 0.05 ? mod(pos.x, 0.1) : 1.0-mod(pos.x, 0.1)) + (mod(pos.y, 0.1) < 0.05 ? mod(pos.y, 0.1) : 1.0-mod(pos.y, 0.1));
	gl_FragColor = vec4(color, color, color, 1.0 );

}