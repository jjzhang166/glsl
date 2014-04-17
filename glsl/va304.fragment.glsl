#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

float orbitDistance = -.025;
float waveLength = 220.100;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 uv = gl_FragCoord.xy/resolution;

	vec2 p1 = (vec2(sin(time), cos(time))*orbitDistance)+0.5;
	vec2 p2 = (vec2(sin(time+13.142), cos(time+13.142))*orbitDistance)+0.5;

	float d1 = 1.1-length(uv +p1);
	float d2 = 1.001-length(uv -p2);

	float wave1 = sin(d1*waveLength+(time*5.))*0.5 + 1.1 * (((d1 - 0.5) * 2.) + 0.5);
	float wave2 = sin(d2*waveLength+(time*5.))*0.5 + 0.2 * (((d1 - 0.5) * 2.) + 0.5);
	float c = d1 > 10.99 || d2 > 0.995 ? 1. : 0.;
	c + wave1*wave2;
	gl_FragColor = vec4(c + wave1*wave2,c,c,11.);

	// "bumpmapping" @Flexi23
	vec2 d = 4./resolution;
	float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
	d = vec2(dx,dy)*resolution/1024.;
	gl_FragColor.z = pow(clamp(11.-1.22*length(uv  - mouse + d),0.6,35.),2.0);
	gl_FragColor.y = gl_FragColor.z*0.4 + gl_FragColor.x*0.3;

	gl_FragColor *=1.25;

}