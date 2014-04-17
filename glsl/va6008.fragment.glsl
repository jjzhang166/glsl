#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool pointInTri(vec2 p, vec2 a, vec2 b, vec2 c)
{
	vec2 v0 = c - a;
	vec2 v1 = b - a;
	vec2 v2 = p - a;

	float dot00 = dot(v0, v0);
	float dot01 = dot(v0, v1);
	float dot02 = dot(v0, v2);
	float dot11 = dot(v1, v1);
	float dot12 = dot(v1, v2);
		
	float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

	return (u >= 0.0) && (v >= 0.0) && (u + v < 1.0);
}

void tri(vec2 p, vec2 a, vec2 b, vec2 c, vec4 tcol, inout vec4 col)
{
	bool inside = pointInTri(p, a, b, c);
	col = inside ? mix(col, tcol, tcol.a) : col;	
}

void main( void )
{
	vec2 p = gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	p.y = 1.0 - p.y;
	p *= 200.0;
	
	vec4 c;
	tri(p, vec2(28, 150), vec2(115, 8), vec2(146, 191), vec4(0.97, 0.70, 0.04, 0.21), c);
	tri(p, vec2(137, 16), vec2(8, 0), vec2(124, 68), vec4(0.87, 0.51, 0.01, 0.25), c);
	tri(p, vec2(118, 19), vec2(200, 123), vec2(134, 135), vec4(0.30, 0.54, 0.25, 0.47), c);
	tri(p, vec2(136, 0), vec2(1, 0), vec2(1, 97), vec4(0.04, 0.39, 0.12, 0.34), c);
	tri(p, vec2(52, 172), vec2(116, 139), vec2(200, 186), vec4(0.12, 0.03, 0.13, 0.99), c);
	tri(p, vec2(96, 12), vec2(195, 73), vec2(142, 198), vec4(0.16, 0.12, 0.01, 0.30), c);
	tri(p, vec2(1, 105), vec2(76, 23), vec2(0, 193), vec4(0.43, 0.65, 0.42, 0.53), c);
	tri(p, vec2(191, 73), vec2(1, 0), vec2(0, 169), vec4(0.94, 0.66, 0.00, 0.19), c);
	tri(p, vec2(181, 89), vec2(72, 194), vec2(33, 160), vec4(0.15, 0.09, 0.25, 0.61), c);
	tri(p, vec2(36, 175), vec2(28, 120), vec2(77, 0), vec4(0.67, 0.56, 0.38, 0.98), c);
	tri(p, vec2(169, 57), vec2(50, 126), vec2(143, 20), vec4(0.76, 0.22, 0.00, 0.24), c);
	tri(p, vec2(169, 71), vec2(86, 81), vec2(174, 129), vec4(0.19, 0.08, 0.02, 0.58), c);
	tri(p, vec2(109, 12), vec2(186, 82), vec2(174, 196), vec4(0.19, 0.20, 0.26, 0.49), c);
	tri(p, vec2(34, 118), vec2(48, 77), vec2(131, 90), vec4(0.41, 0.15, 0.01, 0.20), c);
	tri(p, vec2(1, 200), vec2(145, 89), vec2(199, 200), vec4(0.20, 0.15, 0.02, 0.74), c);
	tri(p, vec2(52, 62), vec2(92, 200), vec2(170, 199), vec4(0.99, 0.77, 0.39, 0.69), c);
	tri(p, vec2(75, 18), vec2(56, 37), vec2(141, 35), vec4(0.17, 0.08, 0.12, 0.75), c);
	tri(p, vec2(38, 72), vec2(33, 100), vec2(179, 90), vec4(0.13, 0.05, 0.03, 0.29), c);
	tri(p, vec2(0, 200), vec2(1, 82), vec2(129, 160), vec4(0.24, 0.29, 0.19, 0.63), c);
	tri(p, vec2(200, 199), vec2(12, 114), vec2(200, 122), vec4(0.31, 0.31, 0.29, 0.44), c);
	tri(p, vec2(19, 111), vec2(149, 36), vec2(48, 34), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(5, 144), vec2(50, 44), vec2(58, 169), vec4(0.09, 0.13, 0.11, 0.26), c);
	tri(p, vec2(140, 71), vec2(100, 190), vec2(133, 160), vec4(0.10, 0.01, 0.00, 0.20), c);
	tri(p, vec2(47, 0), vec2(200, 0), vec2(125, 68), vec4(0.59, 0.55, 0.37, 0.40), c);
	tri(p, vec2(190, 112), vec2(131, 192), vec2(8, 17), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(111, 10), vec2(29, 154), vec2(53, 33), vec4(0.55, 0.10, 0.00, 0.11), c);
	tri(p, vec2(116, 199), vec2(97, 53), vec2(93, 76), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(65, 30), vec2(3, 200), vec2(168, 110), vec4(0.98, 0.90, 0.62, 0.16), c);
	tri(p, vec2(94, 177), vec2(74, 115), vec2(42, 112), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(35, 154), vec2(200, 200), vec2(199, 1), vec4(0.35, 0.35, 0.16, 0.22), c);
	tri(p, vec2(41, 74), vec2(57, 35), vec2(77, 22), vec4(0.31, 0.26, 0.16, 0.88), c);
	tri(p, vec2(106, 54), vec2(84, 89), vec2(81, 157), vec4(0.11, 0.01, 0.01, 0.26), c);
	tri(p, vec2(45, 140), vec2(157, 175), vec2(70, 1), vec4(0.99, 0.86, 0.25, 0.14), c);
	tri(p, vec2(33, 170), vec2(176, 199), vec2(89, 111), vec4(0.26, 0.21, 0.11, 0.30), c);
	tri(p, vec2(200, 64), vec2(200, 200), vec2(137, 200), vec4(0.24, 0.26, 0.17, 0.64), c);
	tri(p, vec2(150, 51), vec2(108, 188), vec2(175, 150), vec4(0.05, 0.18, 0.61, 0.07), c);
	tri(p, vec2(143, 19), vec2(85, 12), vec2(127, 68), vec4(0.22, 0.06, 0.24, 0.67), c);
	tri(p, vec2(173, 68), vec2(0, 109), vec2(140, 11), vec4(0.70, 0.54, 0.17, 0.14), c);
	tri(p, vec2(128, 74), vec2(175, 71), vec2(141, 18), vec4(0.24, 0.14, 0.25, 0.80), c);
	tri(p, vec2(51, 118), vec2(115, 104), vec2(127, 159), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(125, 151), vec2(134, 17), vec2(146, 196), vec4(0.27, 0.22, 0.13, 0.39), c);
	tri(p, vec2(179, 130), vec2(29, 34), vec2(161, 181), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(57, 165), vec2(157, 179), vec2(152, 131), vec4(0.20, 0.14, 0.13, 0.25), c);
	tri(p, vec2(199, 112), vec2(199, 0), vec2(69, 18), vec4(0.27, 0.45, 0.11, 0.34), c);
	tri(p, vec2(38, 131), vec2(98, 161), vec2(134, 82), vec4(1.00, 0.69, 0.37, 0.44), c);
	tri(p, vec2(0, 136), vec2(113, 178), vec2(0, 90), vec4(0.33, 0.33, 0.22, 0.68), c);
	tri(p, vec2(0, 0), vec2(182, 0), vec2(0, 54), vec4(0.17, 0.29, 0.18, 0.16), c);
	tri(p, vec2(0, 199), vec2(68, 200), vec2(53, 44), vec4(0.15, 0.12, 0.09, 0.33), c);
	tri(p, vec2(162, 87), vec2(77, 19), vec2(50, 164), vec4(0.00, 0.00, 0.00, 0.00), c);
	tri(p, vec2(2, 178), vec2(163, 94), vec2(28, 87), vec4(0.00, 0.00, 0.00, 0.00), c);
		
	//gl_FragColor = vec4(p, 0.0, 1.0 );
	gl_FragColor = vec4(c.rgb, 1.0);
}