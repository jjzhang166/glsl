// warping hexagons, WIP. @psonice_cw
// I'm sure there's a less fugly way of making a hexagonal grid, but hey :)

#ifdef GL_ES
precision mediump float;
#endif

float hex(vec2 p, float r){
	p = abs(p);
	return max(p.x+p.y*0.57735,p.y*1.1547)-r;
}

void main(void) 
{ 
	lowp vec2 pos = gl_FragCoord.xy;
	pos.y += mod(gl_FragCoord.x, 100.*0.866025403784439)/(50.*0.866025403784439) < 1. ? 25. : -0.;
	pos = vec2(mod(pos.x, 50.*0.866025403784439), mod(pos.y, 50.));
	lowp vec4 p;
	pos -= vec2(25./0.866025403784439, 25.);
	p = vec4(abs(hex(pos, 28.))<1. ? 0. : 1.);
	gl_FragColor = p; 
	
}
