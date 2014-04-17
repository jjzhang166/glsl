// fuck that shit.

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float waveLength = 50.0;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	float orbitDistance = abs(sin(time+3.142))*0.2 + abs(sin(time*1.7))*0.025;

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 p1 = (vec2(sin(time), cos(time))*orbitDistance)+0.5;
	vec2 p2 = (vec2(sin(time+3.142), cos(time+3.142))*orbitDistance)+0.5;

	float d1 = 0.9-length(gl_FragCoord.xy/resolution +p1);
	float d2 = 0.9-length(gl_FragCoord.xy/resolution -p2);

	float wave1 = sin(d1*waveLength+(time*5.))*0.5 + 0.5 * (((d1 - 0.5) * 2.) + 0.5);
	float wave2 = sin(d2*waveLength+(time*5.))*0.5 + 0.5 * (((d1 - 0.5) * 2.) + 0.8);

	float c = d1 > 0.99 || d2 > 0.995 ? 1. : 0.;
	c += wave2;
	
	vec3 finalColor = vec3(c + wave1 * wave2 * abs(sin(mod(gl_FragCoord.x+gl_FragCoord.y, 2.0))),
			    c + wave2 * abs(sin(mod(gl_FragCoord.x+gl_FragCoord.y, 2.0))),
			    c);

	finalColor += rand(position+time)*0.04;
	gl_FragColor = vec4(finalColor, 0);
}