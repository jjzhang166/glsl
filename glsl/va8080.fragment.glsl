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
	
	float d = length(pos)+10000.0;
	
	// Create the wiggle
	d += (sin(pos.y*0.25/scale+time)*sin(pos.x*0.25/scale+time*.5))*scale*5.0;
	
	d /= radius;
	vec3 m = sin(d*0.2*sin(time+3.1415*(d*vec3(d*+.15, -d*0.33, d*.25)*0.5)));
	
	gl_FragColor = vec4(m, 1.0);
}