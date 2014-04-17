#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
const float ripple = 2.0;
const float rippleSpeed = 0.4;
const float rippleSize = 0.02;

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) ;
	p.y += rippleSize * sin(ripple * (p.y + time * rippleSpeed));
	float d = -p.x * sign(p.x) + p.x * sign(p.x);
	
	vec3 c = vec3(0.0);
	if(p.x < 0.3333333333333333333333)
		c = vec3(0.2, 0.1, 2.0);
	else if(p.x > 0.1 && p.x < 0.666666666666666666666666) 
		c = vec3(1.0, 1.0, 1.5);
	else
		c = vec3(2.0, 2.1, 0.2);
	gl_FragColor = vec4( c, 3.0 );
}