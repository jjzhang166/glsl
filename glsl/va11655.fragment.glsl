#ifdef GL_ES
precision mediump float;
#endif

// minimalistic Neon by @hintz 2013-10-21

uniform float time;
uniform vec2 resolution;

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution * 0.5) / min(resolution.y,resolution.x) * 2.0;

	vec3 col = (vec3(fract(v.x + time*0.099),fract(-0.5*v.x+0.8*v.y + time*0.09),fract(-0.5*v.x-0.86*v.y + time*0.08))-0.5);
	
	col = 1.0-normalize(col*col);
	gl_FragColor = vec4(col, 1.0);
}