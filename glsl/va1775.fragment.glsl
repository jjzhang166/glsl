#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy - (resolution.xy * 0.5) / resolution.x * 2.0;
	vec2 normMouse = (mouse * resolution.xy) - (resolution.xy * 0.5) / resolution.x * 2.0;
	float mouseDistance = length(position - normMouse);

	float waveVal = pow(cos(mouseDistance * 0.1 - time * 3.0),2.0) * 0.9 + 0.1;
	float envelope =  max(cos(min(mouseDistance * 0.007,4.0)), 0.0);
	float color = waveVal * envelope;
	gl_FragColor = vec4( color, color, color, 1.0 );

}