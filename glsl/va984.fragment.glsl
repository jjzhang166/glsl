#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 Mul(vec2 z1, vec2 z2)
{
	return vec2(z1.x * z2.x - z1.y * z2.y, z1.y * z2.x + z1.x * z2.y);
}

vec2 Div (vec2 z1, vec2 z2)
{
	return vec2(z1.x * z2.x + z1.y * z2.y, z1.y * z2.x - z1.x * z2.y) / z2.x * z2.x + z2.y * z2.y;
}

vec2 Liss (float mx, float my)
{
	return vec2 (sin(time * mx / 5.0), cos (time * my / 5.0));
}

void main( void ) {

	vec2 position = (gl_FragCoord.xy - resolution/2.0) / min(resolution.x, resolution.y);

	vec2 a = Liss(1.13, 1.012);
	vec2 b = Liss(1.121, 1.748);
	vec2 c = Liss(1.217, 1.185);
	vec2 d = Liss(1.193, 1.931);
	vec2 e = Liss(1.793, 1.178);
	vec2 f = Liss(1.543, 1.932);
	vec2 g = Liss(1.293, 1.178);
	vec2 h = Liss(1.642, 1.138);
	
	vec2 pos = position * 2.0;
	
	vec2 foo2 = Div (a + Mul (b, Mul (e, Mul (g, pos))), c + Mul(d, Mul (f, Mul (h, pos))));
	//vec2 foo2 = a + Mul (b, position);
	vec2 foo = fract(foo2) - 0.5;

	float color = sign (foo.x * foo.y);
	//color = smoothstep (color, 0.0, 1.0);
	
	gl_FragColor = vec4(color,color,color,1.0);
}