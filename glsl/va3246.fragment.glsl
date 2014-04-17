//@ME

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// original by @psonice  uglified by @neoneye

//@rotate from http://glsl.heroku.com/e#3036.0
// triangles with better AA
// by @neoneye

//patterns! :D
// @scratchisthebes
// Removed that nasty AA! Bring back real pixels! And made it a nice xor-like pattern with radiating circles.
// @psonice

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

float circle(float x, float y, float radius, float softness) {
	vec2 p = vec2(x, y);
	float r = length( p );
	float a = atan( p.y, p.x ) + length(p) * 0.3;
	r *= 1.0 + clamp(1.0-r,0.0,1.0);
	return 1.0-smoothstep( radius, radius + softness, r );
}

float prettify(vec3 v, float rads) {
	v.x = circle(v.x, v.y, v.x, v.x);
	v.xy *= rotate(v.xy, rads);
	v.y = circle(v.y, v.z, v.x, v.y);
	v.zy *= rotate(v.xy, rads * 0.3);
	v.z = circle(v.x, v.z, v.x, v.x);
	v.xz *= rotate(v.yz, rads * 0.009 * time);
	float f = sin(length(v)-0.5);
	f *= 1.3;
	f = clamp(f, -1.0, 1.0);
	f *= 0.5 + 0.5;
	return f;
}

void main( void ) {
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x/resolution.y;
	float rads = radians(time*5.0);
	p = rotate(p, rads);
	vec3 col = vec3( 0.0, 0.0, 0.0 );
	col += sin(circle(p.x+0.2, p.y+0.2, 0.25, 0.0));
	col += circle(p.x-0.2, p.y-0.2, 0.25, sin(mod(time*0.03,1.0)));
	col += circle(p.x+0.2, p.y-0.1, 0.35, cos(mod(time*0.005,1.0)));
	col += circle(p.x-0.3, p.y+0.2, 0.35, tan(mod(time*0.005,1.0)));
	col += circle(p.x-0.4, p.y+0.4, 0.15, sin(mod(time*0.015,1.0)));
	col += circle(p.x+0.4, p.y-0.4, 0.15, sin(mod(time*0.05,1.0)));
	//col += circle(p.x+0.2 + cos(p.x + time) * 0.25, p.y+0.2 + sin(p.y + time) * 0.25, 0.75, 0.0);
	//col += circle(p.x-0.2 - cos(p.x + time) * 0.25, p.y-0.2 - sin(p.y + time) * 0.25, 0.75, 0.0);
	col += circle(p.x+0.2 + sin(p.x + time) * 0.25, p.y-0.2 + cos(p.y + time) * 0.25, 0.85, 0.0);
	//col += circle(p.x-0.2 - sin(p.x + time) * 0.25, p.y+0.2 - cos(p.y + time) * 0.25, 0.85, 0.0);
	//col += circle(p.x-0.4 + sin(p.y + time) * 0.25, p.y+0.4 + cos(p.x + time) * 0.25, 0.65, 0.0);
	col += circle(p.x+0.4 + sin(p.y + time) * 0.25, p.y-0.4 + cos(p.x + time) * 0.25, 0.65, 0.0);
	col += tan((length((q - 0.5)) * 10.) - time);
	col -= p.x * sin(time) * 5.0;
	col -= p.y * sin(time) * 3.0;
	col = sin(col);
	vec3 white = vec3(sin(rads) * 0.5 + 0.5, mod(col.x, 1.0), mod(q, 1.0));
	col = mod(col, 2.);
	//col = col.x > 0.5 ? 1. - col : col;
	col *= white;
	col = vec3(prettify(col, rads));
	gl_FragColor = vec4(col,1.0);

}