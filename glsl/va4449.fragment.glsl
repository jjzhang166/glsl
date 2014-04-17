#ifdef GL_ES
precision mediump float;
#endif

// By rafacacique - https://twitter.com/rafacacique
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141592654;

float usin(float t) {
	return sin(t) * 0.5 + 0.5;
}

void main( void ) {
	float aspect = resolution.x / resolution.y;
	vec3 pos = vec3(gl_FragCoord.xy / resolution.xy, 1.0);// * 2.0 - vec2(1.0);
	pos.x *= aspect;
	
	const float n_iter = 100.0;
	const float x0 = 0.5/n_iter;
	
	float r = 0.0;
	for (float i = 0.0; i < n_iter; i++) {
		float freq = 1.5*(i+1.0)/n_iter;
		float x = x0+i/n_iter;
		float y = 0.5;
		y += sin(time)*sin(freq*time)*0.2;
		
		vec3 circPos = vec3(x*aspect, y, 1.0);
		float f = 0.15;
	
		float sinTime = 1.0-usin(time)*0.3;
		float dx = pos.x - circPos.x;
		float dy = pos.y - circPos.y;
		float d = 7.5*(dx*dx + dy*dy);		
		r += f/(d*150.*sinTime);
	}
	
	float g = 0.0;
	for (float i = 0.0; i < n_iter; i++) {
		float freq = 3.0*(i+1.0)/n_iter;
		float x = x0+i/n_iter;
		float y = 0.5;
		y += sin(freq*time+PI)*0.15;
		
		vec3 circPos = vec3(x*aspect, y, 1.0);
		float f = 0.5;
	
		float sinTime = 1.0-usin(time)*0.05;
		float dx = pos.x - circPos.x;
		float dy = pos.y - circPos.y;
		float d = 10.0*(dx*dx + dy*dy);
		g += f/(d*150.*sinTime);
	}
	
	float b = 0.0;
	for (float i = 0.0; i < n_iter; i++) {
		float freq = 4.5*(i+1.0)/n_iter;
		float x = x0+i/n_iter;
		float y = 0.5;
		y += cos(freq*time)*0.15;
		
		vec3 circPos = vec3(x*aspect, y, 1.0);
		float f = 0.75;
	
		float sinTime = n_iter-usin(time)*0.2*i;
		sinTime /= n_iter;
		float dx = pos.x - circPos.x;
		float dy = pos.y - circPos.y;
		float d = 10.2*(dx*dx + dy*dy);
		b += f/(d*150.*sinTime);
	}	
	
	float p = usin(time)*0.5+0.5;
	float q = 1.5 - p;
	vec4 color = vec4(r, q*g, p*b, 1.0);
	color *= 1.0 - usin(2.0*time)*0.1;
	
	gl_FragColor = color;
}