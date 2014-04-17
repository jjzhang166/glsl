#ifdef GL_ES
precision mediump float;
#endif

uniform vec2  resolution;
uniform float time;
uniform sampler2D backbuffer;
uniform vec2 mouse;

const int num_x = 5;
const int num_y = 5;
float w = resolution.x;
float h = resolution.y;
 
vec4 draw_ball(int i, int j) {
	float t = time/4.0;
	float x = (w/2.0) + w/2.0 * (cos(1.5 * t + float(3*i+4*j)));
	float y = (h/2.0) + h/2.0 * (sin(2.3 * t + float(3*i+4*j)));
	float size = 3.0 - 2.0 * sin(t);
	vec2 pos = vec2(x, y);
	float dist = length(gl_FragCoord.xy - pos);
	float intensity = pow(size/dist, 1.5);
	vec4 color = vec4(0.0);
	color.r = abs(sin(t*float(i)))*sin(mouse.x)*10.0;
	color.g = abs(cos(t*float(i)))*sin(mouse.y)*10.0;
	color.b = abs(sin(t*float(j)))*sin(mouse.x+mouse.y)*10.0;
	return color*intensity;
}

void main() {
	vec4 color = vec4(0.0);
	for (int i = 0; i < num_x; ++i) {
		for (int j = 0; j < num_y; ++j) {
			color += draw_ball(i, j);
		}
	}
	vec2 texPos = vec2(gl_FragCoord.xy/resolution);
	vec4 shadow = texture2D(backbuffer, texPos)*0.1;
	gl_FragColor = color + shadow;
}