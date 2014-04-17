#ifdef GL_ES
precision mediump float;
#endif

#define pi 3.141592653589793238462643383279

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sandWatch(vec2 position){
	float s = tan(-position.x * pi) * 0.6;
	float s2 = tan(position.x * pi) * 0.6;
	
	if (position.y >= s2 && position.x <= 0.5){
		return 1.0;
	}
	if (position.y >= s && position.x >= 0.5){
		return 1.0;
	}
	return 0.0;
}

void main(void) {

	vec2 position = (gl_FragCoord.xy / resolution.xy);
	
	if (cos(time * cos(position.x) * sin(position.y)) > 0.1){
		gl_FragColor = vec4(1, 1, 0, 1);
		return;
	}

	gl_FragColor = vec4(1.0, sandWatch(position), 0.0, 1.0);

}