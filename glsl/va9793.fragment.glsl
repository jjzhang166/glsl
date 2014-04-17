#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(1.0) * 0.5;
	pos.x *= resolution.x / resolution.y;
	float ang = atan(pos.y, pos.x) + 3.14159 + time;
	float dis = length(pos);
	vec4 light = vec4(0.8, 0.8, 0.8, 1.0);
	if(dis > 0.2 && dis < 0.3 + step(mod(ang * 2.0, 1.0), 0.5) * 0.05) gl_FragColor = light;

}