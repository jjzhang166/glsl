#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 cmult(vec2 a, vec2 b)
{
	vec2 p;
	p[0]=a[0]*b[0]-a[1]*b[1];
	p[1]=a[0]*b[1]+a[1]*b[0];
	return p;
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy )
		- vec2(0.5, 0.5)
		- (mouse.xy-vec2(0.5,0.5))*2.0;

	position = position / 1.0;

	vec2 c, c0, d;
	float v;
	
	c = vec2(0,0);
	c0 = vec2(position);
	
	vec2 f = position.xy;
	for(int i=0; i<100; i++) {
		d = cmult(c, c);
		c = d + c0;
		v = c.x*c.x + c.y*c.y;
		if (v > 1.0) break;
	}
	
	gl_FragColor = vec4( v, c.x, c.y, 1.0 );

}