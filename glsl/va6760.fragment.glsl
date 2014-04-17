// warping hexagons, WIP. @psonice_cw
// I'm sure there's a less fugly way of making a hexagonal grid, but hey :)

//  Maybe - Try this...

// Simplify!

// @eddbiddulph - modulated hexagons by the hexagon shape itself, and added some colour.

// 70's progressive hexagon remix!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// 1 on edges, 0 in middle
float hex(vec2 p) {
	p.x *= 0.57735*2.0;
	p.y += mod(floor(p.x), 2.0)*0.5;
	p = abs((mod(p, 1.0) - 0.5));
	return abs(max(p.x*1.5 + p.y, p.y*2.0) - 1.0);
}

vec3 palette(float i) 
{
	i = mod(i, 3.0);
	if(i < 1.0)
		return vec3(1.0, 1., 0.);
	else if(i < 2.0)
		return vec3(1., .0, 1.);
	else
		return vec3(0., .5, 1.0);
}

void main(void) { 
	vec2 pos = gl_FragCoord.xy;
	
	vec2 p = pos/40.0; 
	p=p-5.5;
	p=vec2(p.x*cos(time)+p.y*sin(time),p.y*cos(time)-p.x*sin(time));
	p+=5.5;
	
	float d = (hex(pos / 400.0) + time) * 0.4;
	d=tan(cos(d)*1.5);
	float df = fract(d);
	float di = floor(d);

	float r = 1.0 - (smoothstep(1.0, 0.3, df) - smoothstep(0.3, 0.6, df));
	vec3 col=palette(r*3.+di+150.*length((p/resolution)-0.5)+time) * smoothstep(r, r + 0.05, hex(p));
	gl_FragColor.rgb = col;
	gl_FragColor.a = 1.0;
}
