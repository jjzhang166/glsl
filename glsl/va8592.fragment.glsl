#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.141592653589793

// tiles by @hintz 2013-05-08

void main(void)
{
	vec2 position = 10.0*(gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.x;
	
	float a = 0.1*time*M_PI/3.0;
	float r = length(position);
	float c = cos(a);
	float s = sin(a);
	mat2 rotate = mat2(c,s,-s,c);
	vec2 q = 1.0+sin(position+M_PI*sin(time-position.yx));
	vec2 q2 = 1.0+sin(1.2*position+M_PI*sin(time-1.4*position.yx));
q = sqrt(abs(q*rotate));
	
	vec3 color = sqrt(normalize(vec3(q.x-q2.y, reflect(q.x,q.y)+q2.y, q.y+reflect(q2.x,q2.y))));
	
	gl_FragColor = vec4(color, 1.0);
}