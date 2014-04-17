/*
 * Author: Yours3!f
 * Ripple effect taken from here (glsl.heroku.com/e#2757)
 * This flag has proper colors (not just r = 1, b = 1)
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const vec3 red = vec3(206, 17, 38) / vec3(255);
const vec3 green = vec3(0, 135, 81) / vec3(255);

const float ripple = 7.0;
const float rippleSpeed = 0.35;
const float rippleSize = 0.01;

void main(void) 
{
	vec2 p = (gl_FragCoord.xy / resolution.xy);
	vec4 c = vec4(1);
	
	p.y += rippleSize * sin(ripple * (p.x + time * rippleSpeed));
	float d = -p.x * sign(p.y) + p.y * sign(p.x);
	
	if(p.y > 0.66)
		c.xyz = red;	
	else if(p.y < 0.33)
		c.xyz = green;
	gl_FragColor = c;
		
}