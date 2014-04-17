#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

float orbitDistance = 0.025;
float waveLength = 100.100;

void main( void ) {
	vec2 uv = gl_FragCoord.xy/resolution;
	
	vec2 p1 = (vec2(sin(time), cos(time))*orbitDistance)/mouse.x;
	vec2 p2 = (vec2(sin(time), cos(time))*orbitDistance*mouse.y);

	float d1 = length(uv -p2);
	float d2 = length(uv +p1);

	float wave1 = sin(d1*waveLength+(time*d1))*0.3 + 0.5 * (((d1 - mouse.x) * 2.) + 0.5);
	float wave2 = sin(d2*waveLength+(time*d2))*0.5 + 0.5 * (((d2 - mouse.y) * 2.) + 0.5);
	float c = d1 > 0.99 || d2 > 0.55 ? 1. : 0.;
	c + wave1*wave2;
	gl_FragColor = vec4(c + wave1*wave2,c,c,1.);

	gl_FragColor *=1.0;

}