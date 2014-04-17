#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 8.0 - 4.0 * mouse;
	float x = sin(time + length(position.xy)) + cos(time + position.x);
	float y = cos(time + length(position.xy)) + sin(time + position.y);
	gl_FragColor = vec4(x * 0.6,y,1./sqrt(x*y),25.0);
}