#ifdef GL_ES
precision mediump float;
#endif

#define MAX_ITER 25
#define ESCAPE 4.
#define Y_MULTI 2.

#define RED 0.1
#define GREEN 0.1
#define BLUE 0.1
#define SATURATION 0.9

#define TIME_MOD 1300.
#define POSITION_MOD 0.00019

#define P_X_OFFSET 0.5
#define P_Y_OFFSET -0.5

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// miles@resatiate.com
vec4 milesbrot(vec2 p, float t, vec4 c) {
	t = TIME_MOD + t;
	
	p.x += P_X_OFFSET;
	p.y += P_Y_OFFSET;	
	
	p.x += t * ((((-.1 + mouse.x) / 1.5) / resolution.x) * 3.5);
	p.y += t *((((.1 + mouse.y) / 3.) / resolution.y) * 1.5);
	
	
	float x0 = (p.x * 1.5) - 2.5;
	float y0 = (p.y * 2.) - 1.;
	vec3 m = vec3(RED, GREEN, BLUE);	
	float x_sqr = 0.;
	float y_sqr = 0.;
	float x_temp = 0.;
	for(int i = 0; i < MAX_ITER; i++) {
		x_sqr = m.x * m.x;
		y_sqr = m.y * m.y;
		if ((x_sqr + y_sqr) < ESCAPE) {
			x_temp = x_sqr - y_sqr + y0;
			m.y = Y_MULTI * m.x * m.y + x0;
			m.x = x_temp;
			m.z = max(m.x, m.y);
		}
	}	
	m += c.xyz;
	m *= c.xyz;
	// repeat
	c = vec4(m, 1.0);
	p = c.xy;
	
	p.x += P_X_OFFSET;
	p.y += P_Y_OFFSET;	
	
	p.x += t * ((((-.1 + mouse.x) / 1.5) / resolution.x) * 3.5);
	p.y += t *((((.1 + mouse.y) / 3.) / resolution.y) * 1.5);	
	
	x0 = (p.x * 1.5) - 2.5;
	y0 = (p.y * 2.) - 1.;
	
	m = vec3(RED, GREEN, BLUE);
	
	for(int i = 0; i < MAX_ITER; i++) {
		x_sqr = m.x * m.x;
		y_sqr = m.y * m.y;
		if ((x_sqr + y_sqr) < ESCAPE) {
			x_temp = x_sqr - y_sqr + y0;
			m.y = Y_MULTI * m.x * m.y + x0;
			m.x = x_temp - dot(m, c.xyz);//atan(dot(m, c.xyz), x_temp) * x_temp;
			m.z = dot(m, c.xyz) * min(m.x, m.y);//min(m.x, m.y) / cos(time * 0.1);			
		}
	}	
	m -= c.xyz;
	m *= c.xyz;
	
	return vec4(m, 1.0);
}

void main( void ) {

	vec3 p = gl_FragCoord.xyz;
	
	p *= POSITION_MOD;
	
	vec4 c = vec4(RED, GREEN, BLUE, 1.);
	c = milesbrot(p.xy, time, c);
		
	gl_FragColor = c * SATURATION;
}