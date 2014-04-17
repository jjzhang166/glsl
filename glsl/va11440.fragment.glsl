#ifdef GL_ES
precision mediump float;
#endif

uniform vec2  resolution;
uniform float time;
uniform sampler2D backbuffer;

const int num_x = 5;
const int num_y = 5;
float w = resolution.x;
float h = resolution.y;
 
vec4 draw_ball(int i, int j) {
	float t = time;
	float x = w/4.0 * (1.0 + cos(0.1 * t + float(3*i+4*j)));
	float y = h/4.0 * (1.0 + sin(1.0 * t + float(3*i+4*j)));
	float size = 3.0 - 2.0 * sin(t);
	vec2 pos = (vec2(x, y))+vec2(w/4.,h/4.);
	float dist = length(gl_FragCoord.xy - pos);
	float intensity = pow(size/dist, 2.0);
	vec4 color = vec4(0.0);
	color.r = 0.5 + cos(t*float(i));
	color.g = 0.5 + sin(t*float(i));
	color.b = 0.5 + sin(float(i));
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
	float mul=1.;
	vec4 sum=vec4(0);
	vec2 cn=0.5*vec2(cos(time*1.5),sin(time*2.3))+vec2(0.5,0.5);
	for (int a=0;a<8;a++)
		{
		sum+=texture2D(backbuffer, ((texPos-cn)*(mul))+cn);
		mul*=0.99;
		}
	gl_FragColor = color+ (sum/8.26);
}
