#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int ITERATIONS = 100;
const float ESCAPE = 4.;

void main( void ) {

	vec2 p = ((( gl_FragCoord.xy / resolution.xy ) ) - vec2(0.29,0) - (mouse - vec2(0.5,0.5)));
	p.x *= resolution.x  / resolution.y;
	vec3 c = vec3(0,0,0);
	vec2 z = vec2(0,0);
	
	for ( int i = 0 ; i < ITERATIONS ; i++) {
		
		float zx = z.x;
		
		z.x = z.x*z.x - z.y*z.y + 2.*(p.x-0.5);
		z.y = 2.*zx*z.y + 2.*(p.y-0.5);
		
		if (dot(z,z) >= ESCAPE) {
			c.r = float(i) / float(ITERATIONS);
			break;
		}
	}	
	
	gl_FragColor = vec4(c, 1.0);

}