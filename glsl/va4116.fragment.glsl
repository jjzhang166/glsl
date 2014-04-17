#ifdef GL_ES
precision mediump float;
#endif

#define MAX_ITER 100
#define ESCAPE 4.
#define Y_MULTI 2.

#define RED 0.01
#define GREEN 0.01
#define BLUE 0.01
#define SATURATION 100.9

#define TIME_MOD 1500.
#define POSITION_MOD 0.00009

#define P_X_OFFSET 0.5
#define P_Y_OFFSET -0.5

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

// miles@resatiate.com
vec4 milesbrot(vec2 p, float t, vec4 c) {
	t = TIME_MOD + t;
	
	//p.x += P_X_OFFSET;
	//p.y += P_Y_OFFSET;	
	
	//p.x += t * (surfacePosition.x / resolution.x);
	//p.y += t * (surfacePosition.y / resolution.y);
	
	//p += surfacePosition;
	
	float x0 = p.x;//(p.x * 1.5) - 2.5;
	float y0 = p.y;//(p.y * 2.) - 1.;
	vec3 m = vec3(RED, GREEN, BLUE);	
	float x_sqr = 0.;
	float y_sqr = 0.;
	float x_temp = 0.;
	vec2 z;
	float e;
	for(int i = 0; i < MAX_ITER; i++) {
		x_sqr = m.x * m.x;
		y_sqr = m.y * m.y;
		if ((x_sqr + y_sqr) < ESCAPE) {
			x_temp = x_sqr - y_sqr + y0;
			m.y = Y_MULTI * m.x * m.y + x0;
			m.x = x_temp;
			m.z = e;//min(m.x, m.y);
			z = cos(p) + vec2(x_sqr - y_sqr, 2.0*m.x*m.y);
			e = dot(tan(z), cos(p));			
		}
	}	
	m += c.xyz;
	m *= c.xyz;
	// repeat
	c = vec4(m, 1.0);
	p = c.xy;
	
	//p.x += P_X_OFFSET;
	//p.y += P_Y_OFFSET;	
	
	p.x += t * (mouse.x / resolution.x);
	p.y += t * (mouse.y / resolution.y);
	
	//p += surfacePosition;
	
	x0 = p.x;//(p.x * 1.5) - 2.5;
	y0 = p.y;//(p.y * 2.) - 1.;
	
	m = vec3(RED, GREEN, BLUE);
	
	for(int i = 0; i < MAX_ITER; i++) {
		x_sqr = m.x * m.x;
		y_sqr = m.y * m.y;
		if ((x_sqr + y_sqr) < ESCAPE) {
			x_temp = x_sqr - y_sqr + y0;
			m.y = Y_MULTI * m.x * m.y + x0;
			m.x = x_temp;
			m.z = e;//min(m.x, m.y);
			z = cos(p) + vec2(x_sqr - y_sqr, 2.0*m.x*m.y);
			e = dot(tan(z), cos(p));
		}
	}	
	m += c.xyz;
	m *= c.xyz;
	
	return vec4(m, 1.0);
}

void main( void ) {
	
	vec4 c = vec4(RED, GREEN, BLUE, 1.);
	c = milesbrot(surfacePosition, time, c);
		
	gl_FragColor = c * SATURATION;
}