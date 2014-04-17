// Ben-a-long-Day by @watdo
// hex function by @psonice_cw

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;
float PI = 3.14159265358979323846264;

// 1 on edges, 0 in middle
float hex(vec2 p) {
	p.x *= 0.57735*2.0;
	p.y += mod(floor(p.x), 2.0)*0.5;
	p    = abs((mod(p, 1.0) - 0.5));
	return abs(max(p.x*1.5 + p.y, p.y*2.0) - 1.0);
}

void main(void) { 
	vec2 	mpos 	= resolution*mouse;

	float	t1   	= 0.08*sin(time*2.+0.4)+0.10;
	float	t2   	= 0.08*sin(time*2.+0.4)+0.10;
	
	vec2 o = gl_FragCoord.xy;
	o = vec2(sin(o.x*.03 + sin(time)*2.) + sin(o.y*.03 + cos(time)*2.), 0.);
	o *= 1.;
	o = pow(o.x, sin(time)*.5+1.) * sign(o) * 4.;
	vec2	r	= (gl_FragCoord.xy + o)/10.0;	
	vec2	l	= (gl_FragCoord.xy - o)/10.0;
	float	lr   	= smoothstep(0.1, 0.2, hex(r));
	float	lb   	= smoothstep(0.1, 0.2, hex(l));
	gl_FragColor	= vec4(lr,lb, lb, 0.0);
	//gl_FragColor = vec4(o);
}
