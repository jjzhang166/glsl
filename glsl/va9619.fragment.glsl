
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec2 cmul(const vec2 c1, const vec2 c2)
{
	return vec2(
		c1.x * c2.x - c1.y * c2.y,
		c1.x * c2.y + c1.y * c2.x
	);
}

vec2 cdiv(const vec2 c1, const vec2 c2)
{
	return vec2(
		(c1.x*c2.x + c1.y*c2.y),
		(c1.y*c2.x - c1.x*c2.y)
	)/(c2.x*c2.x + c2.y*c2.y);
}

vec2 cpow(const vec2 c1, const vec2 c2)
{
	return pow(c1, c2);	
}

void main( void ) {
	vec2 p = surfacePosition;
	vec2 c = p;
	float iter = 0.0;
	for (int i = 0; i < 40; i++) {
		float phi = atan(c.y, c.x)+atan(mouse.y*2.0-1.0, mouse.x*2.0-1.0)*iter;
		float r = length(c);
		if (r > sin(time)+5.0) break;
		c.x = ((cos(2.0*phi))/(r*r)) + p.x;
		c.y = (-sin(2.0*phi)/(r*r)) + p.y;
		
		iter++;
	}
	gl_FragColor = vec4(1.0 - iter / 40.0);
}