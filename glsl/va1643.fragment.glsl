
#ifdef GL_ES
precision mediump float;
#endif

// @RicoTweet 
// If you want to learn more about how to make Mandelbrot sets watch http://youtu.be/t75gXyWJNpA 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
//const vec2 c = vec2(.0, .0);
//const vec2 c = vec2(.835, -.2321);
//const vec2 c = vec2(0.25, .0);
//const vec2 c = vec2(0.25, .5);
//const vec2 c = vec2(0.4, .6);
//const vec2 c = vec2(0.285, .0);
//const vec2 c = vec2(0.3, .5);

const float MAX = 42.; 

vec2 pow2(const vec2 z) { 		
	float a = z.x; 
	float b = z.y; 
	float c = z.x; 
	float d = z.y; 
	
	float r = a*c - b*d; 
	float i = a*d + b*c; 
	return vec2(r,i); 
}

vec2 f(const vec2 z) {
	return pow2(z) + (mouse - 0.5) * 5.0; 
}

vec3 getColor(float color) {
	vec3 col;
	//Colors!
	if (color > 2.8) {
		col = vec3(0.5, 0.5, smoothstep(0.5, 1.0, color - 2.9));	
	} else if (color > 1.0) {
		col = vec3(0.5, color - 1.0, 0.5);
	} else {
		col = vec3(color, 0.0, 0.0);
	}
	return col;
}

void main() {  
	vec2 p = (gl_FragCoord.xy / resolution.xy) - 0.5;
	p.y /= resolution.x / resolution.y;
	p /= 0.2;
	
	vec2 z = p; 
	vec2 znm1;
	
	vec3 col = vec3(0.0);
	float color = 3.0;
	
	for(float i = 0.; i != MAX; i++) {
		znm1 = z; 
		z = f(z); 		 	
		float sub = (i / (MAX * 2.)) * 0.5; 
		
		color -= sub;
		
		if(length(z) > 20.0) {
			col = getColor(color);
			break;
		}		
	}
	
	gl_FragColor = vec4(col, 1.0); 
}