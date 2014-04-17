#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float w = 32.0;
	float pi = 3.1416;
	float pih2 = pi / 2.0;
	float alpha, beta;
	alpha = (0.25*cos(time) + 0.25*sin(time));
	float a = (gl_FragCoord.y * alpha) * pi * 4.0 / resolution.y;
	
	float o = resolution.x / 2.0;

	float x0 = o + w * sin(a);
	float x1 = o + w * sin(a+pih2);
	float x2 = o + w * sin(a+2.0*pih2);
	float x3 = o + w * sin(a+3.0*pih2);
	
	vec4 col = vec4(0.0);
	float s0, s1, s2, s3;
	s0 = step(x0, x1) * step(x0, gl_FragCoord.x) * step(gl_FragCoord.x, x1);
	s1 = step(x1, x2) * step(x1, gl_FragCoord.x) * step(gl_FragCoord.x, x2);
	s2 = step(x2, x3) * step(x2, gl_FragCoord.x) * step(gl_FragCoord.x, x3);
	s3 = step(x3, x0) * step(x3, gl_FragCoord.x) * step(gl_FragCoord.x, x0);
	
	vec4 c0 = vec4(1.0, 0.0, 0.0, 0.0);
	vec4 c1 = vec4(0.0, 1.0, 0.0, 0.0);
	vec4 c2 = vec4(0.0, 0.0, 1.0, 0.0);
	vec4 c3 = vec4(1.0, 0.0, 1.0, 0.0);

	col = s0*c0 + s1*c1 + s2*c2 + s3*c3;
	
	gl_FragColor = col;

}