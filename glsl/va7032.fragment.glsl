/*
 * Title: Time for Fun
 * Tweaked by: dapumptu
 * Simplified chessboard function, added techno vibe. Psonice
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
	vec2 p = gl_FragCoord.xy/resolution.xy - 0.5;
	p = vec2(pow(p.x, 0.25), pow(p.y, 0.25));
	float bpm = 100.;
	bpm = bpm*4./60.;
	p *= abs(sin(time*bpm))*.25+1.;
	p += vec2(sin(time*bpm*.12), cos(time*bpm*.125)) * 1.;
	float check = chessboard(p, vec2(8.));
	vec3 bb = texture2D(backbuffer, (1.+sin(time*bpm*.25)*.05) * (gl_FragCoord.xy/resolution.xy-.5)+.5).rgb * vec3(.8, .8, 0.9);
	//check += check < 0.5 ? bb * 0.9 : (1.-bb * 0.9);
	gl_FragColor = vec4(check + (check < 0.5 ? bb * 0.99 : bb * 0.), 1.);
}