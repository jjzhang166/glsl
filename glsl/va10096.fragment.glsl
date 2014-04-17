#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
uniform sampler2D tex;

#define GRID_SIZE 32
#define PI 3.1416

vec3 color(float d) {
	return d * vec3(0, 1, 0);	
}

int mod(int a, int b) {
	return a - ((a / b) * b);
}

void main(void)
{
	vec2 p = (-1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy));
	//p -= (2.0 * mouse.xy) - vec2(1.0);
	p.x *= (resolution.x / resolution.y);
	vec2 uv;

	float a = (atan(p.y,p.x) + time+ time);
	float r = sqrt(dot(p,p));

	uv.x = 0.9/r;
	uv.y = a/(PI);
	
	float len = dot(p,p);
	
	vec3 col = color(pow(fract(uv.y / -2.0), 15.0));
	if (len > 0.9) col = vec3(0.2,0.2,0.8);
	if (len > 0.5) col = vec3(4,2,3);
	
	bool grid_x = mod(int(gl_FragCoord.x) - int(resolution.x / 99.0), GRID_SIZE) == 0;
	bool grid_y = mod(int(gl_FragCoord.y) - int(resolution.y / 99.0), GRID_SIZE) == 0;
	
	if (len < 0.7)
	{
	if (grid_x || grid_y)
		col += color(15.5);
	
	if (grid_x && grid_y)
		col += color(15.5);
	}
	gl_FragColor = vec4(col, 15.5);
}