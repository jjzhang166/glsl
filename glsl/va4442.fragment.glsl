#ifdef GL_ES
precision mediump float;
#endif

/*
 * @prompto
 * Mongolian flag in progress...
 */

uniform float time;
uniform vec2 resolution;
const float ripple = 7.0;
const float rippleSpeed = 0.5;
const float rippleSize = 0.05;

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) ;
	p.y += rippleSize * sin(ripple * (p.y + time * rippleSpeed));
	float d = -p.x * sign(p.x) + p.x * sign(p.x);
	
	vec3 c = vec3(0.0);
	if(p.x < 0.3333333333333333333333)
		c = vec3(1.0, 0.2, 0.2);
	else if(p.x > 0.3333333333333333 && p.x < 0.666666666666666666666666) 
		c = vec3(0.2, 0.2, 1.0);
	else
		c = vec3(1.0, 0.2, 0.2);
	gl_FragColor = vec4( c, 1.0 );
}