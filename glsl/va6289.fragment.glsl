/*
If anyone is reading this, please help fixing this Quaternion.
Aw I'm such a douche.
*/

#ifdef GL_ES
precision highp float;
#endif
void main( void ) {//about:blank glsl style!
}

/*
//Messed up noob coder stuff begins here

precision mediump float;
uniform vec2 resolution;
uniform float time;
uniform int r;
uniform int i;
uniform float Threshold;
uniform vec4 C;
uniform float p2;
uniform vec4 p;
uniform vec4 dp;


void main( void ) {
	vec4 p = vec4(pos, 0.0);
	vec4 C = vec4(0.18,0.88,0.24,0.16);
	vec4 dp = vec4(1.0, 0.0,0.0,0.0);
	for (int i = 0; i < 16; i++) {
		dp = 2.0* vec4(p.x*dp.x-dot(p.yzw, dp.yzw), p.x*dp.yzw+dp.x*p.yzw+cross(p.yzw, dp.yzw));
		p = vec4(p.x*p.x-dot(p.yzw, p.yzw), vec3(2.0*p.x*p.yzw)) + C;
		float p2 = dot(p,p);
		orbitTrap = min(orbitTrap, abs(vec4(p.xyz,p2)));
		if (p2 > 12.963) break;
	}
	float r = length(p);
	return  0.5 * r * log(r) / length(dp);
}
*/
