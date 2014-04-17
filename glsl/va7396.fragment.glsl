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
	position.xy = vec2(position.x * cos(t) + position.y * sin(t), -position.x * sin(t) + position.y * cos(t));
	float tr = time * r0*.7;
	position.xy = vec2(cos(.01*tr)*position.x + sin(.015*tr)*position.y, cos(.002*tr)*position.y-sin(.007*tr)*position.x);
	position.xy *= sin(position.xy);
	
	float r = length(position)*50.0;
	r += .09 * (sin((angle + time*0.015) * 100.0) + cos((angle + time*0.01) * 100.0));
	
	gl_FragColor = vec4(fract(r*3.0), fract(r*0.2), fract(r*0.7), 1.0);
}