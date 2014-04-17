#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0 + vec2(sin(time / 5.0) / 2.0, cos(time / 5.0) / 2.0);
	position.x *= 6.0;
	position.y *= 4.0;

	float  factor1 = - abs(sin(position.x * 4.0 * 1.54)) + 1.0 - 0.5 * (sin(position.x * 4.0 * 3.14) * 0.5 + 0.5);
	float  factor2 = - abs(sin((position.y * 1.0 * position.x) * 3.0 * 1.54 / 2.0)) + 1.0 - 0.5 * (sin((position.y * 1.0 * position.x) * 3.0 * 3.14 / 2.0) * 0.5 + 0.5); 
	float  factor3 = - abs(sin((position.y * 2.0 * position.x) * 2.0 * 1.54 / 3.0)) + 1.0 - 0.5 * (sin((position.y * 2.0 * position.x) * 2.0 * 3.14 / 3.0) * 0.5 + 0.5);
	float  factor4 = - abs(sin((position.y * 3.0 * position.x) * 1.0 * 1.54 / 4.0)) + 1.0 - 0.5 * (sin((position.y * 3.0 * position.x) * 1.0 * 3.14 / 4.0) * 0.5 + 0.5);
	float  factor5 = - abs(sin(position.y * 4.0 * 1.54 / 5.0)) + 1.0 - 0.5 * (sin(position.y * 4.0 * 3.14 / 5.0) * 0.5 + 0.5);
	float factor = ((factor2 + factor3 + factor4) / 3.0);
	gl_FragColor = vec4(factor, factor, factor, 1.0 );

}