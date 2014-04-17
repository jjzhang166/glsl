// PsychoBen-Day by @watdo
// hex function by @psonice_cw

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
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
	vec4 final = vec4(0.0, 0.0, 0.0, 0.0);

	
	float offset = 10.0;
	float size = 50.0;
	
	for(float i = 0.; i < 3.; i++){
		float	t1 = 0.5;
		float	t2 = 0.3;
		
		float rx = gl_FragCoord.x/(i * size)  + time + (i * offset);
		float ry = gl_FragCoord.y/(i * size) + time - (i * offset);
		
		float lr = smoothstep(t1, t2, hex(vec2(rx, ry)) / 0.2);
		float r = cos(sin(time) / 2.0) - lr;
		float g = cos(time / 2.0) + lr;
		float b = sin(cos(time) / 2.0) + lr;
		final += vec4(r - 0.8,g - 0.8 ,b - 0.8,0.0);
	}
	
	gl_FragColor = vec4(final);
}
