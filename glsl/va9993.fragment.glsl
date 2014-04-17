#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float color = 0.0;
	float x_distance = abs(pos.x - mouse.x);
	float y_distance = abs(pos.y - mouse.y);
	float distance = sqrt(x_distance * x_distance + y_distance * y_distance);
	
	float foo = clamp(distance + cos(time) * 0.01, 0.0, 1.0);
	color = (1.0) / ((foo) * 8.0);
	
	float r = clamp(color + (cos(time) * 0.1), 0.0, 1.0);
	float g = clamp(color + (sin(time) * 0.1), 0.0, 1.0);
	float b = clamp(color + ((sin(time) + cos(time)) * 0.01), 0.0, 1.0);
	gl_FragColor = vec4(r, g, b, 1.0);
}