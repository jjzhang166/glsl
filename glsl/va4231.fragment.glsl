// @mod* by rotwang
// symmetric beam and colorizing 

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
	return d * vec3(1, 1, 0);	
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

	float a = (atan(p.y,p.x) + time);
	float r = sqrt(dot(p,p));

	uv.x = 0.1/r;
	uv.y = a/(PI);
	
	float len = dot(p,p);

	float da = pow(fract(uv.y / -2.0), 15.0);
	float db = pow(fract(uv.y / 2.0), 15.0);
	float d = da+db;
	float dd = length(p)*2.0;
	vec3 col = vec3(dd,1.0,0.0) * d; 
	vec3 cb = vec3(1.0,1.0,0.0) * db;
	
	
	float rd = smoothstep(0.7, 0.75, len);
	col *= 1.0-rd;
	
	
	bool grid_x = mod(int(gl_FragCoord.x) - int(resolution.x / 2.0), GRID_SIZE) == 0;
	bool grid_y = mod(int(gl_FragCoord.y) - int(resolution.y / 2.0), GRID_SIZE) == 0;
	
	if (len < 0.7)
	{
	if (grid_x || grid_y)
		col += color(0.1);
	
	if (grid_x && grid_y)
		col += color(1.0);
	}
	gl_FragColor = vec4(col, 1.0);
}