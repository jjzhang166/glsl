// DMT 4U&ME

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.xx - 0.6*mouse.xy + 0.3;
	float r0 = length(position);
	float angle = atan(position.y, position.x);
	float t = time*0.2;
	position.xy = vec2(position.x * cos(t) + position.x * tan(t), -position.x * tan(t) + position.y * cos(t));
	float tr = time * r0*.7;
	position.xy = vec2(cos(.1*tr)*position.x + sin(.015*tr)*position.y, tan(.02*tr)*position.y-sin(.007*tr)*position.x);
	position.xy *= tan(position.xy);
	
	float r = length(position)*50.0;
	r += .2 * (sin((angle + time*0.015) / 100.0) + tan((angle + time*0.01) * 100.0));
	
	gl_FragColor = vec4(fract(r*3.0), fract(r*0.2), fract(r*0.7), 1.0);
}