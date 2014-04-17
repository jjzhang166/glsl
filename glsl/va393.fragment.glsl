#ifdef GL_ES
precision highp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float getN(vec2 offset) {
	return texture2D(backbuffer, (gl_FragCoord.xy + offset) / resolution.xy).x;
}

void main( void ) {
	vec2 relpos = gl_FragCoord.xy / resolution.xy;
	
	if (distance(relpos, mouse.xy) < 0.005) {
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	} else {
		float n = getN(vec2(-1.0, -1.0)) + 
				getN(vec2(0.0, -1.0)) + 
				getN(vec2(1.0, -1.0)) + 
				getN(vec2(-1.0, 0.0)) +  
				getN(vec2(1.0, 0.0)) +
				getN(vec2(-1.0, 1.0)) + 
				getN(vec2(0.0, 1.0)) +
				getN(vec2(1.0, 1.0));
		if (abs(getN(vec2(0.0, 0.0))) < 0.001) {
			if (abs(n - 3.0) < 0.001) {
				gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
			} else {
				gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			}
		
		} else if (n < 2.0 || n > 3.0) {
			gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
		} else { // m <= 3
			gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
		}
	}
}