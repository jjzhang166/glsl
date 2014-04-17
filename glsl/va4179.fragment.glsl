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



void main(void)
{
	vec2 p = (-1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy));
	p.x *= (resolution.x / resolution.y);

	float a = (atan(p.y,p.x) + time);
	float r = sqrt(dot(p,p));
	r += r * sin(time);
	float d = abs(a-r)/(PI);
	
	
	vec3 col = color(pow(fract(d / -2.0), 3.0));
	col.x = r*0.25;

	gl_FragColor = vec4(col, 1.0);
}