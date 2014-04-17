#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = gl_FragCoord.xy - (resolution.xy * 0.5) / resolution.x * 2.0;
	vec2 normMouse = (mouse * resolution.xy) - (resolution.xy * 0.5) / resolution.x * 2.0;
	float mouseDistance = length(position - normMouse);

	float waveVal = pow(cos(mouseDistance * 0.1 - time * 3.0),2.0) * 0.9 + 0.1;
	float envelope =  max(cos(min(mouseDistance * 0.007,4.0)), 0.0);
	float color = waveVal * envelope;
	vec4 back=texture2D(backbuffer,gl_FragCoord.xy/resolution);
	color*=0.2;
	gl_FragColor = vec4( back.r*.99+color, back.g*0.98+color, back.b*0.0/color, 1.0 );
}