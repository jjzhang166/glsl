#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec2 LEFT_EYE = vec2(-0.9, 0.3);
const vec2 RIGHT_EYE = vec2(0.3, 0.5);

void main( void ) {
	vec2 pos = (gl_FragCoord.xy-resolution.xy/2.0) / min(resolution.x, resolution.y) * 2.0;
	vec2 pointer = mouse / 5.0 - 0.1;

	vec3 color = vec3(sin(time * 5.0), 0, 0);
	
	pos = vec2(
			pos.x * cos( time ) - pos.y * sin( time ),
			pos.x * sin( time ) + pos.y * cos( time )
	);
	if(length(pos) < 0.8) {
		if(length(pos - LEFT_EYE) < 0.2 || length(pos - RIGHT_EYE) < 0.2) {
			if(length(pos - LEFT_EYE - pointer) < abs(0.1 + 0.05 * sin(10.0*time)) || length(pos - RIGHT_EYE - 2.0 * pointer) < 0.02 + 0.01 * abs(cos(time))) {
				color = vec3(sin(time * pos.x),cos(time* 2.0 * pos.y),tan(time/4.0 * pos.xy));
			} else {
				color = vec3(1);
			}
		} else if(length(pos - vec2(0.0, -0.5)) < 0.6 && pos.y > -0.5 + 0.1*sin(20.0*time)) {
			color = vec3(0);
		} else {
			color = vec3(pos.x * abs(sin(time)) + 0.5, pos.y * abs(cos(time)) + 0.5, 0);
		}
	}

	gl_FragColor = vec4(color, 1.0);

}