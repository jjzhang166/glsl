// Half-assed prism, full of hacks, undefined behavior, wrong behavior and doesn't even disperse light.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define LINE(p, d, a, m, f) (clamp((m) - (f) * distance(p + dot((d), (a)-(p)) * d, a), 0.0, max(dot(d, (a)-(p)), 0.0)))
#define LINEM(p, d, a, m, f, g) (clamp((m) - (f) * distance(p + dot((d), (a)-(p)) * d, a), 0.0, max(dot(d, (a)-(p)) - 9001.0 * max(0.0, dot(d, (a)-(p)) - g), 0.0)))
#define CRS(v, w) ((v).x*(w).y-(v).y*(w).x)
#define CRS(v, w) ((v).x*(w).y-(v).y*(w).x)
#define INTERSECTT(q, r, p, s) ((CRS((q)-(p), s) / max(0.0001, abs(CRS((r), (s)))) * sign(CRS((r), (s)))))
#define INTERSECT(q, r, p, s) ((q) - (r) * INTERSECTT(q, r, p, s))
void main( void ) {

	vec2 position = ( gl_FragCoord.xy );
	
	vec3 col = vec3(0.0, 0.0, 0.0);
	vec2 nd = vec2(0.0, 1.0);
	vec2 sp = vec2(0.0, resolution.y * 0.25);
	vec2 sd = normalize(mouse * resolution.xy - sp);
	vec2 op = vec2(resolution.x * 0.2, 0.0);
	vec2 od = normalize(vec2(1.0, 1.6));
	vec2 on = vec2(od.y, -od.x);
	vec2 op2 = vec2(resolution.x * 0.7, 0.0);
	vec2 od2 = normalize(vec2(-1.0, 1.6));
	float md = atan(sd.y, sd.x);
	vec2 md0 = vec2(cos(md - 0.2), sin(md - 0.2));
	vec2 md1 = vec2(cos(md - 0.4), sin(md - 0.4));
	vec2 mm0 = vec2(cos(md - 0.4), sin(md - 0.4));
	vec2 mm1 = vec2(cos(md - 0.6), sin(md - 0.6));
	
	float t = INTERSECTT(sp, sd, op, od);
	float tt = INTERSECTT(op, od, op2, od2);
	vec2 pp = sp - sd * t;
	float mt0 = INTERSECTT(pp, md0, op2, od2);
	float mt1 = INTERSECTT(pp, md1, op2, od2);
	vec2 mp0 = pp - md0 * mt0;
	vec2 mp1 = pp - md1 * mt1;
	col += LINEM(sp, sd, position, 2.0, 1.0, -t);
	col += pow(LINEM(sp, sd, position, 1.0, 0.01, -t), 4.0) * 0.3;
	col += LINE(pp, normalize(reflect(sd, on)), position, 2.0, 1.0) * 0.1;
	col += LINEM(op, normalize(od), position, 2.0, 1.0, -tt);
	col += LINEM(op2, normalize(od2), position, 2.0, 1.0, -tt);
	col += LINEM(pp, md0, position, 1.0, 0.2, -mt0) * 0.5;
	col += LINEM(pp, md1, position, 1.0, 0.2, -mt1) * 0.5;
	col += LINE(mp0, mm0, position, 2.0, 1.0) * 0.5;
	col += LINE(mp1, mm1, position, 2.0, 1.0) * 0.5;
	col += pow(LINE(mp0, mm0, position, 1.0, 0.01), 4.0) * 0.3;
	col += pow(LINE(mp1, mm1, position, 1.0, 0.01), 4.0) * 0.3;
	gl_FragColor = vec4(col,  1.0 );

}