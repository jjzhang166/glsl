#ifdef GL_ES
precision mediump float;
#endif

// MILES@RESATIATE.COM

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 fractal_mandle(vec2 p, float t, vec4 color) {
	t = 2000. + t;
	
	p.x += 0.95;
	p.y += -.95;	
	
	p.x += t * ((((-0.2 + mouse.x) / 15.) / resolution.x) * 3.5);
	p.y += t *((((0.2 + mouse.y) / 5.) / resolution.y) * 1.5);	
	
	float x0 = (p.x * 1.5) - 2.5;
	float y0 = (p.y * 2.) - 1.;
	vec3 mandle = vec3(0., 0., 0.);	
	
	float x_exp = 0.;
	float y_exp = 0.;
	float x_temp = 0.;
	
	int max_iteration = 0;
	for(int i = 0; i < 30; i++) {
		x_exp = mandle.x * mandle.x;
		y_exp = mandle.y * mandle.y;
		if ((x_exp + y_exp) < 4.) {
			x_temp = x_exp - y_exp + y0 - mandle.z;
			mandle.y = 2.* mandle.x * mandle.y + x0;
			mandle.x = x_temp + (mandle.z * mandle.y);
			mandle.z = float(i / 6) / (y0 * (mandle.x / mandle.z));
			
			max_iteration = i;
		}
	}	
	
	return vec4(color.xyz * (float(max_iteration) / 25.), 1.0);
}

void main( void ) {

	vec3 p = gl_FragCoord.xyz;
	
	p = p * 0.000909;
	
	vec4 c = vec4(p.xyz, p.t);

	c = fractal_mandle(c.xy, time, c);
	c = fractal_mandle(p.xy, time, c);
	c = fractal_mandle(p.xy * exp(p.y - p.x), time, c);
	
	gl_FragColor = c * 1.;
}