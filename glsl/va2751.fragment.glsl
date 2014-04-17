#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define pi 3.1415927410125

void main()
{
	vec2 pos = gl_FragCoord.xy / resolution - mouse;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	float t = time / 0.5 + 1.0 /u;
	
	
	vec3 col = vec3(-sin(u*4.0+t*2.0+time), sin(u*8.0+v-time), cos(v+u*3.0+time))*16.0;
	if (mod(u*64.0,2.0)>32.0) col=vec3(0.,0.,0.);
	if (u*8.>4.) col = vec3(mod(time,u/2.));
	
	gl_FragColor = vec4(col, 1.0);
}