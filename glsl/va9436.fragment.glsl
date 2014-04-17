#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int circles = 10;
const float spacing = 0.02;
const float depth = 0.1;
const float begin = 0.05;
const int bendc = 5;
const float benda = 0.2;
const float PI = 3.1415;
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
	vec2 t = vec2(sin(time), cos(time)) * 0.2;
	p.x *= resolution.x / resolution.y;
	m -= 0.5;
	
	vec3 c = vec3(0,0,0);
	
	for (int i = 0 ; i < circles ; i++) {
		c += drawCircle(
			p,
			vec2(
				/*center of screen*/resolution.x / resolution.y/2. + /*mouse coord*/m.x*float(i+1)*depth + /*time offset*/t.x*float(circles-i)*depth,
				/*center of screen*/0.5 + /*mouse coord*/m.y*float(i+1)*depth + /*time offset*/t.y*float(circles-i)*depth + /*bend*/ sin(PI/2.*float(i+bendc)/float(circles)) * benda ),
			float(i)*spacing + begin);
	}
	gl_FragColor = vec4(c,0);
}