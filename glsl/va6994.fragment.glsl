/*
 * Title: Time for Fun
 * Tweaked by: dapumptu
 * Date: 2013.02.26
 *
 * Version: 1.0
 *
 * Thanks to the time variable, we have an interesting visual effect here
 *
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float two_pi = 4.0 * asin(1.0);
const float proj_coeff = 0.2;
const float rot_coeff = 0.05;
const float move_coeff = 0.3;
const float fog_coeff = 1.8;
const float fog_exp = 0.1;

float chessboard(vec2 uv, vec2 nuv)
{
	bool pu = (mod(ceil(uv.x * nuv.x), 2.0) == 0.0);
	bool pv = (mod(ceil(uv.y * nuv.y), 2.0) == 0.0);
	
	return (pu && !pv) || (!pu && pv) ? 0.0 : 1.0;
}

vec4 texture(vec2 pos)
{
	float fval = chessboard(pos, vec2(12.0, 30.0));
	return vec4(fval, fval, fval, 1.0);
}

void main( void ) {
	gl_FragColor = texture(gl_FragCoord.xy * time/ resolution.xy);
}