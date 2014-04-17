#ifdef GL_ES
precision mediump float;
#endif

// x := tan(x)^2+c

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAX = 145; 

vec2 f(const vec2 z, const vec2 m) {
	float a = z.x; 
	float b = z.y; 
	
	
	float g = cos(a)*(exp(b)+exp(-b))*.5;
	float h = -sin(a)*(exp(b)-exp(-b))*.5;
	float inv = 1./(g*g+h*h);
	float r = g * inv;
	float i = h * -inv;
	
	float r2 = sin(a)*(exp(b)+exp(-b))*.5;
	float i2 = cos(a)*(exp(b)-exp(-b))*.5;
	
	float e = r*r2-i*i2;
	float f = i*r2+r*i2;
	
	
	return vec2(e*e-f*f,2.*e*f)+vec2(cos(time)+20., sin(time)+10.)*.00016;
}

void main() {
	vec2 p = (vec2(gl_FragCoord.xy / resolution.xy) - .5) * vec2(resolution.x / resolution.y, 1.0) * 10.;
	
	vec2 z = p; 
	
	for(int i = 0; i != MAX; i++) {
		z = f(z,p);
		
		if(length(z) > 40000.) {
			gl_FragColor = vec4(vec3(i / MAX), 1.0) ; 
			return; 
		}		
	}
	 
	gl_FragColor = .25 + vec4(z.x, z.y, (1.-z.x)* (1. - z.y), 1.0); 
}