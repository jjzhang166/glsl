#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int circles = 15;
const float spacing = 0.02;
const float depth = 0.1;

vec3 drawCircle(vec2 p, vec2 pos, float size) {
	
	float psize = 1./resolution.y;
	vec3 c = vec3(0,0,0);	

	c.x =  -size + distance(p, pos);
	c.x *=  size-psize - distance(p, pos);
	c = sign(c);
	c.x += 1.;
	return c;
}

void main( void ) {
	
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 m = mouse.xy;
	p.x *= resolution.x / resolution.y;
	m -= 0.5;
	
	vec3 c = vec3(0,0,0);
	
	for (int i = 0 ; i < circles ; i++) {
		c += drawCircle(p, vec2(resolution.x / resolution.y/2. + (depth * m.x * float(circles-i)),0.5 + (depth * m.y * float(circles-i))), 0.40 - float(i)*spacing);
	}
	gl_FragColor = vec4(c,0);
}