#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x *= resolution.x / resolution.y;
	vec2 mou = mouse;
	mou.x *= resolution.x / resolution.y;
	float d = distance(position, mou);
	if (d < 0.01) {
		gl_FragColor = fract(sin(vec4(position*546356.5, mou*32859.4565)*time));
	} else if (d < 0.04) {
		vec2 c = mou;
		vec2 dir = mou - position;
		c += dir;
		c /= resolution.x / resolution.y;
		gl_FragColor = texture2D(backbuffer, c);
	} else if (d < 0.1) {
		gl_FragColor = texture2D(backbuffer, mou - 0.01);	
	} else if (d < 0.2) {
		gl_FragColor = texture2D(backbuffer, mou + 0.01);	
	} else {
		gl_FragColor = texture2D(backbuffer, mou + 0.05);
	}
}