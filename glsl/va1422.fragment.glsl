#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x *= resolution.x / resolution.y;

	vec2 mouseadj = mouse;
	mouseadj.x *= resolution.x / resolution.y;
	float fill = sin(length(position - mouseadj) * 15.0 - time * 0.3) * 1.5 + 0.7;
	
	float a = 1.0;
	float sc = 37.3;
	vec2 p = position * sc * mat2(cos(a), -sin(a), sin(a), cos(a));
	p.x += time;
	p = mod(p, 1.0) - 0.5;
	gl_FragColor.r = length(p) * 15.0 - 10.0 + 6.0 * fill;

	a = 3.0;
	sc = 43.7;
	p = position * sc * mat2(cos(a), -sin(a), sin(a), cos(a));
	p.x += time * 1.69858;
	p = mod(p, 1.0) - 0.5;
	gl_FragColor.g = length(p) * 12.0 - 10.0 + 6.0 * fill;

	a = 5.0;
	sc = 46.3;
	p = position * sc * mat2(cos(a), -sin(a), sin(a), cos(a));
	p.x += time * 1.3523;
	p = mod(p, 1.0) - 0.5;
	gl_FragColor.b = length(p) * 15.0 - 10.0 + 6.0 * fill;
		
	gl_FragColor.a = 1.0;
}