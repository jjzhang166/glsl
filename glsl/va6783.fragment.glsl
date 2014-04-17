
// based on warping hexagons, WIP. @psonice_cw
// who said:Simplify!
// and i reply: Compleximux!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;


// 1 on edges, 0 in middle
float hex(vec2 p) {
	p.x *= 1.57735*2.0;
	p.y += mod(floor(p.x), 2.0)*0.5;
	p = abs((mod(p, 1.0) - 0.5));
	return abs(max(p.x*1.5 + p.y, p.y*2.0) - 1.0);
}


void main(void) { 
	vec2 pos = gl_FragCoord.xy;
	vec2 p = pos - .5 * float(resolution);
	p = p/40.;

	float t = time * 2. + length(p)*.2;
	mat2 rot = mat2(cos(t), -sin(t), 
			sin(t), cos(t));
	p = p * rot;

	float jump = pow(abs(sin(5.*time)), .03);
	p = p * jump;




	vec2 offset1 = vec2(.1, .1);
	vec2 offset2 = vec2(-.1, .15);

	float  r = (1.0 + cos(time*10.))*0.5;
	r = r*(1.-r);

	float levelr = smoothstep(r, r + 0.05, hex(p));
	float levelg = smoothstep(r, r + 0.05, hex(p+offset1));
	float levelb = smoothstep(r, r + 0.05, hex(p+offset2));
	gl_FragColor = vec4(levelr, levelg, levelb, 1.0);
}
