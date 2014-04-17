#ifdef GL_ES
precision mediump float;
#endif

#define MAX_ITER 200
#define ESCAPE 4.
#define Y_MULTI 2.

#define RED 1.0
#define GREEN 0.0
#define BLUE 0.0

#define SATURATION 1.

#define TIME_MOD 2500.
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
	
	float x_ratio = mouse.x / resolution.x;
	float y_ratio = mouse.y / resolution.y;
	
	p.x += TIME_MOD * x_ratio;
	p.y += TIME_MOD * y_ratio;
	
	
	float x0 = (p.x * 1.5) - 2.5;
	float y0 = (p.y * 2.) - 1.;
	vec3 m = vec3(RED, GREEN, BLUE);	
	float x_sqr = 0.;
	float y_sqr = 0.;
	float x_temp = 0.;
	float max_i = 0.;
	for(int i = 0; i < MAX_ITER; i++) {
		x_sqr = m.x * m.x;
		y_sqr = m.y * m.y;
		if ((x_sqr + y_sqr) < ESCAPE) {
			x_temp = x_sqr - y_sqr + y0;
			m.y = Y_MULTI * m.x * m.y + x0 * sin(float(i));
			m.x = x_temp - m.z;
			m.z = float(i) / (2. * float(MAX_ITER));
			
			max_i++;
		}
	}	
	
	vec3 outer = m;

	p = m.xy;
	
	p.x += P_X_OFFSET;
	p.y += P_Y_OFFSET;

	p.x += TIME_MOD * x_ratio * sin(t * 0.1);
	p.y += TIME_MOD * y_ratio * cos(t * 0.1);	
	
	x0 = (p.x * 1.5) - 2.5;
	y0 = (p.y * 2.) - 1.;
	//max_i = 0.;
	
	m = vec3(RED, GREEN, BLUE);	
	for(int i = 0; i < MAX_ITER; i++) {
		x_sqr = m.x * m.x;
		y_sqr = m.y * m.y;
		if ((y_sqr + x_sqr) < ESCAPE / .1) {
			x_temp = x_sqr - y_sqr + y0;
			m.y = Y_MULTI * m.x * m.y + x0;
			m.x = x_temp * cos(m.z);
			m.z = mod(mod(mod(m.x, m.y), mod(y0, x0)), mod(float(MAX_ITER), max_i));
			max_i++;
		}
	}	
	m.xy += outer.yx;
	m *= outer.z;
	
	return vec4(m, 1.0);
}

void main( void ) {

	vec3 p = gl_FragCoord.xyz;
	
	p *= POSITION_MOD;
	
	vec4 c = vec4(RED, GREEN, BLUE, 1.);
	c = milesbrot(p.xy, time, c);
		
	gl_FragColor = c * SATURATION;
}