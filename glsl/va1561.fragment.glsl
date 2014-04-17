#ifdef GL_ES
precision mediump float;
#endif

// Julia fractal using the function x := sin(x) + d/x^2.

// c depends on mouse position, d on time.


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float MAX = 45.; 
vec2 c = vec2(cos(time),sin(time))*1.0;
float invF = sin(time*1.1)*.5;


vec2 f(const vec2 z, const vec2 m) {
	float a = z.x; 
	float b = z.y; 
	float e = a * m.x - b * m.y;
	float f = b * m.x + a * m.y;
	float g = e*e-f*f;
	float h = 2.*e*f;
	
	float inv = 1./(g*g+h*h);
	
	
	float r = sin(a)*(exp(b)+exp(-b))*.5 + g * inv;
	float i = cos(a)*(exp(b)-exp(-b))*.5 - h * inv;
	return vec2(r,i)*.25; 
}

void main() {
	vec2 p = (vec2(gl_FragCoord.xy / resolution.xy) - vec2(.5,.5)) * .5 * vec2(resolution.x / resolution.y, 1.0);
	
	vec2 z0 = p*14.;
	
	vec2 z = z0; 
	vec2 znm1; 
	
	vec2 sum = vec2(0.0); 
	
	for(float i = 0.; i != MAX; i++) {
		znm1 = z; 
		z = f(z,c);
		sum += z - znm1;  
		
		if(length(z-z0) > 40000.) {
			gl_FragColor = vec4(vec3(i / MAX), 1.0) ; 
			return; 
		}		
	}
	 
	gl_FragColor = .5 + vec4(z.x, z.y, (1.-z.x)* (1. - z.y), 1.0); 
}