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
	float	t2   	= 0.08*sin(time*2.+0.4)+0.25;
	
	float	rx	= (gl_FragCoord.x+( mpos.x*0.0625 ))/30.0;
	float	ry	= (gl_FragCoord.y+( mpos.y*0.0625 ))/30.0;	
	float	bx	= (gl_FragCoord.x+(-mpos.x*0.125))/40.0;
	float	by	= (gl_FragCoord.y+(-mpos.y*0.125))/40.0;

	float	lr   	= smoothstep(t1, t2, hex(vec2(rx ,  ry)));
	float	lb   	= smoothstep(t1, t2, hex(vec2(bx , -by)));
	gl_FragColor	= vec4(lr, lb, lb, 0.0);
}
