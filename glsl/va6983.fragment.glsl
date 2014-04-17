#ifdef GL_ES
precision mediump float;
#endif
//Still a wip- trying out some noise functions.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi = 3.1415927;
float movescale = 3.3;

vec2 c1 = vec2(1., 1.);
vec2 c2 = vec2(1., -1.);
vec2 s1 = vec2(1., 0.);
vec2 s2 = vec2(0., 1.);

ivec2 ic1 = ivec2(1, 1);
ivec2 ic2 = ivec2(1, -1);
ivec2 is1 = ivec2(1, 0);
ivec2 is2 = ivec2(0, 1);

float random(in float a, in float b) { return fract((cos(dot(vec2(a,b) ,vec2(12.9898,78.233))) * 43758.5453)); }
float cerp(in float a, in float b, in float c) {
	float f = (1. - cos(c * pi)) * .5;
	return (a*(1.-f)+b*f);
}


float snoise(in float x, in float y) {
	float i = floor(x), j = floor(y);
	float u = x-i, v = y-j;
	
	float a = random( i   , j   );
	float b = random( i+1., j   );
	float c = random( i   , j+1.);
	float d = random( i+1., j+1.);
	
	float v1 = cerp(a, b, u);
	float v2 = cerp(c, d, u);
	
	
	return cerp(v1, v2, v);
}

float pnoise(in float x, in float y) {
	vec2 pos = vec2(x, y);
	float c = snoise(pos.x, pos.y)*.5;
	float f = 1.131; 	
	float ff = f;
	
	float p = 0.4733; 	
	float pp = p;
	
	for(int i = 0; i < 3; i++) {
		c += snoise(pos.x*ff, pos.y * ff) * pp;
		ff *= f;
		pp *= p;
	}
	c /= .05*sqrt(x*x+y*y);
	return c;
}


float combineNoise(in float x, in float y) {
	vec2 pos = vec2(x, y);
	vec2 pos1 = pos;
	vec2 pos2 = pos;
	vec2 pos3 = pos;
	
	float t = time;
	
	pos1 += movescale*1.5*vec2(sin(t*.32)*.2, sin(t*.33)*.5);
	t *= 8.;
	pos2 += movescale*1.1*vec2(sin(t*.31)*.3, sin(t*.41)*.3);
	t *= .25;
	pos3 += movescale*1.1*vec2(sin(t*.23)*.7, sin(t*.31)*.4);
	
	float c;
	c = pnoise(pos1.x, pos1.y)*.2;
	c += pnoise(pos2.x * .3, pos2.y *.3)*.1;
	c += pnoise(pos3.x * 1.5, pos3.y * 1.5)*.35;
	return c;
}


void main(void) {
	vec2 pos = -1.+2.*(gl_FragCoord.xy/resolution.xy);
	
	pos *= 135.5;
	
	float r = combineNoise(pos.x, pos.y)*.3;
	float g = combineNoise(pos.x*1.5, pos.y*1.5) * .3;
	float b = combineNoise(pos.x*.5, pos.y*.5) * .3;
	
	
	gl_FragColor = vec4(r, g, b, 1);
}








































