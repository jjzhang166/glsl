#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21
// modified by @hintz

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	float scale = resolution.y / 50.0;
	float radius = resolution.x;
	vec2 pos = gl_FragCoord.xy - resolution.xy*0.5;
	
	float d = 100000.;
	
	// Create the wiggle
	d += (sin(pos.y*0.1/scale+time)*sin(pos.x*0.1/scale+sin(time)/time*1000.0))*scale*.5;
	
	d /= radius;
	vec3 m = (d*.2*sin(time*sin(time/10.0)/150.0+3.1415*(d*vec3(d*.15, -d*.33, d*.25)*.5)));
	
	gl_FragColor = vec4(m, 1.0);
}