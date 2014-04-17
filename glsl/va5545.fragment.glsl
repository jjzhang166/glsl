// Do the Mario!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

int getPixel(int x, int y)
{
	int a = x + y * 8;

	if(a > 32 && a < 39 || a > 42 && a < 46)return 1;
	if(a > 1 && a < 6 || a > 11 && a < 14 || a > 15 && a < 21 && a != 18 || a == 22 || a == 26 || a == 28)return 2;
	if(a == 6 || a > 8 && a < 12 || a == 14 || a == 15 || a == 18 || a == 21 || a == 23 || a == 29 || a == 30)return 3;
	
	return 0;
}

vec3 getColor(int palette, int pixel)
{
	if(palette == 0)return pixel == 0 ? vec3(0.0, 0.0, 0.0):
	                       pixel == 1 ? vec3(1.0, 0.0, 0.0):
	                       pixel == 2 ? vec3(1.0, 0.8, 0.7):
	                                    vec3(0.0, 0.0, 1.0);
	
	                return pixel == 0 ? vec3(0.0, 0.0, 0.0):
	                       pixel == 1 ? vec3(1.0, 1.0, 1.0):
	                       pixel == 2 ? vec3(1.0, 0.6, 0.0):
	                                    vec3(0.3, 0.6, 0.0);
	
	return vec3(0.0, 0.0, 0.0);
}

void main()
{
	float angle = sin(time * 0.3) / 2.0;
	float zoom = (cos(time) + 2.0) * 8.0;
	
	mat2 matrix = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
	vec2 coord = matrix * gl_FragCoord.xy;
	vec2 uv = mod(coord / resolution * vec2(8.0 * zoom, 6.0 * zoom), vec2(16.0, 12.0));	
	gl_FragColor = vec4(getColor(int(fract(time / 4.0) * 2.0), getPixel(int(uv.x), int(uv.y))), 1.0);
}