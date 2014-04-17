/*
 * Title: Time for Fun
 * Tweaked by: dapumptu
 * Date: 2013.02.28
 *
 * Version: 1.1
 *
 * Thanks to the time variable, we have an interesting visual effect here.
 *
 * - Use a simplified chessboard function from Psonice
 * - Add some color variations
 *
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float two_pi = 4.0 * asin(1.0);
const float proj_coeff = 0.2;
const float rot_coeff = 0.05;
const float move_coeff = 0.3;
const float fog_coeff = 1.8;
const float fog_exp = 0.1;

float chessboard(vec2 uv, vec2 nuv)
{
	uv = floor(mod(uv*nuv, 2.));
	return mod(uv.x+uv.y, 2.);
}

vec4 texture(vec2 pos)
{
	float fval = chessboard(pos, vec2(0.00001, 10.0));
	return vec4(fval, fval, fval, 1.0);
}

void main( void ) {
	vec2 p = gl_FragCoord.xy/resolution.xy * time * 0.125;
	float check = chessboard((p * cos(time*time*0.00025)), vec2(16.));
	gl_FragColor = vec4(sin(check*time*0.25), sin(check*time*0.25), cos(check*time*0.25), 1.);
}