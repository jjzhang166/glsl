#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec2 LEFT_EYE = vec2(-0.3, 0.3);
const vec2 RIGHT_EYE = vec2(0.3, 0.3);

void main( void ) {
	vec2 pos = (gl_FragCoord.xy-resolution.xy/2.0) / min(resolution.x, resolution.y) * 2.0;
	vec2 pointer = mouse / 5.0 - 0.1;

	vec3 color = vec3(0);
	
	if(length(pos) < 0.8) {
		if(length(pos - LEFT_EYE) < 0.2 || length(pos - RIGHT_EYE) < 0.2) {
			if(length(pos - LEFT_EYE - pointer) < abs(0.1 * sin(time)) || length(pos - RIGHT_EYE - pointer) < 0.1* abs(cos(time))) {
				color = vec3(0);
			} else {
				color = vec3(1);
			}
		} else if(length(pos) < 0.6 && pos.y < 0.0) {
			color = vec3(0);
		} else {
			color = vec3(1, 1, 0);
		}
	}

	gl_FragColor = vec4(color, 1.0);

}