#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 fractal_mandle(vec2 p, float t, vec4 c) {
	t = 2000. + t;
	
	p.x += .5;
	p.y += -1.56;	

	
	p.x += t * ((((0.1 + mouse.x) / 20.) / resolution.x) * 3.5);
	p.y += t *((((0. + mouse.y) / 9.5) / resolution.y) * 1.7);
	
	
	float x0 = (p.x * 1.5) - 2.5;
	float y0 = (p.y * 2.) - 1.;
	float z0 = (c.x * 2.) - 1.;
	vec3 mandle = vec3(0., 0., 0.);	
	//float xy_sum = x+y;
	float x_exp = 0.;
	float y_exp = 0.;
	float x_temp = 0.;
	//float xy_exp = exp(xy_sum);
	int max_iteration = 0;
	for(int i = 0; i < 40; i++) {
		x_exp = mandle.x * mandle.x;
		y_exp = mandle.y * mandle.y;
		if ((x_exp + y_exp) < 4.) {
			x_temp = x_exp - y_exp + y0 + (mandle.x * mandle.z);
			mandle.y = 2.* mandle.x * mandle.y + x0;
			mandle.x = x_temp + z0;
			mandle.z = float(i / 80) + x_exp + y0;
			
			max_iteration = i;
		}
	}	
	
	float a = .0;
	
	float scale = float(max_iteration) / 80.;
	a = .00000001;
	
	//vec4 approx = fractal_2n_1(c.xy, t, c);// vec4(0., 0., 0., 0.);
	//approx = appr_mandle(p);
	
	float red = mandle.x;
	float green = mandle.y;
	float blue =  mandle.z;
	
	vec3 rgb = vec3(red + c.x, green + c.y, blue + c.z);
	rgb *= scale;
	//rgb *= approx_north.xyz * 10000.;
	
	return vec4(rgb, a);
}

vec4 appr_mandle(vec2 p) {
	return vec4(p.xy, p.xy);
	p.x += 0.95;
	p.y += -0.95;	
	
	float x0 = (p.x * 1.5) - 2.5;
	float y0 = (p.y * 2.) - 1.;
	vec3 mandle = vec3(0., 0., 0.);	
	float x_exp = 0.;
	float y_exp = 0.;
	float x_temp = 0.;
	int max_iteration = 0;
	for(int i = 0; i < 2; i++) {
		if (i < 2) {
			x_exp = mandle.x * mandle.x;
			y_exp = mandle.y * mandle.y;
			if ((x_exp + y_exp) < 4.) {
				x_temp = x_exp - y_exp + y0 + mandle.z;
				mandle.y = 2.* mandle.x * mandle.y + x0;
				mandle.x = x_temp;
				mandle.z = float(i) * y0;
				
				max_iteration = i;
			}
		}
	}	
	
	float scale = float(max_iteration / 2);
	
	vec3 rgb = vec3(mandle.x, mandle.y, mandle.z);
	rgb *= scale;
	
	return vec4(rgb, 0.1); 
}

vec4 fractal_2n_1(vec2 p, float t, vec4 color) {
	float dt = abs(mod(t, 350.) - 700.);
	dt = dt / 35.;
	
	float a = .0;

	float scale = .1;
	
	float red = (dt / (0.4 * (p.x / dt)) - 1.);
	float green = (dt / (3.2 * (p.y / dt))) - 1.;
	float blue = (dt / (2.3 * dt)) - 1.;
	
	vec3 rgb = vec3(red * color.x, green * color.y, blue * color.z);
	
	return vec4(rgb, a);
}

vec4 fractal_spins(vec2 p, float t, vec4 color) {
	float dt = abs(mod(t, 350.) - 700.);
	dt = dt / 350.;
	
	float a = .01;

	float scale = .1;
	
	float red =  exp(sin(p.y) * p.x - cos(p.y)) + log(p.y - 3.2);
	float green = sin(sin(p.y) * p.x - cos(p.y)) + log(p.y - 3.2);
	float blue = cos(sin(p.y) * p.x - cos(p.y)) + log(p.y - 3.2);
	
	vec3 rgb = vec3(red * color.x, green * color.y, blue * color.z);
	
	return vec4(rgb, a);
}
vec4 fractal_original(vec2 p, float t, vec4 color) {
	float dt = t / 1.;
	float a = 0.01;
	
	float scale = 0.0;
	scale += sin( p.x * cos( t / 51.0 ) * 82.0 ) + cos( p.y * cos( t / 15.0 ) * 10.0 );
	scale += sin( p.y * sin( t / 11.0 ) * 23.0 ) + cos( p.x * sin( t / 25.0 ) * 40.0 );
	scale += sin( p.x * sin( t / 61.0 ) * 130.0 ) + sin( p.y * sin( t / 35.0 ) * 80.0 );
	scale *= ( dt / 5.0 ) * 0.25;
	
	scale = (t - (scale * t)) / t;

	//color = vec4(0.2, 0.4, 0.1, a);	
	
	float red =(t - (color.y * t)) / t;
	float green = sqrt(color.x) * mod(color.y, 0.5) / 0.74;
	float blue = cos(dt / 1.5 ) * 0.75;	
	
	vec3 rgb = vec3(red + color.x, green + color.y, blue + color.z);
	
	return vec4(rgb, a);
}


void main( void ) {

	vec3 p = gl_FragCoord.xyz;
	
	p = p * 0.000909;
	
	vec4 c = vec4(p.xyz, p.t);
	//int maxi = int((mouse.x / resolution.x) * 1.); 
	for (int i = 0; i < 5; i++) {
		//if (i > maxi) {
		//c = fractal_spins(c.xy, time, c);
		//c = fractal_2n_1(c.xy, time, c);
		//c = approx_mandle(p.xy);
		c = fractal_mandle(p.xy, time, c);
		//c = fractal_spins(c.xy, time, c);
		//c = fractal_2n_1(c.zy, time, c);
		//c = fractal_original(c.xy, time, c);
		//}
	}
//c = fractal_original(c.xy, time, c);
//c = fractal_mandle(c.xy, time, c);

//c = c * 0.9;
//c = fractal_mandle(c.xy, time, c);
//c = fractal_mandle(c.xy, time, c);
	//c = fractal_mandle(c.xy, time, c);
	//c = fractal_mandle(c.xy, time, c);
c = c * vec4(1., 0.1, 0.9, 0.9);
c = fractal_2n_1(c.xy, time, c);
c = fractal_spins(c.xy, time, c);
c = fractal_original(c.xy, time, c);
c = fractal_mandle(p.xy + c.xy, time, c);
//c = c * vec4(1., 0.45, .9, 0.1);
	
	gl_FragColor = c * 1.;
}