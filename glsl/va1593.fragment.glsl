// @RicoTweet
// WORK IN PROGRESS. 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float MAX_ITER = 256.; 
const float MAX_QUAD = 4.; 
const vec2 c = vec2(.0, .0); 

vec2 point(float cx, float cy) {
	float quad = 0.; 
	float x = 0.; 
	float y = 0.;  
	
	for(float iter = 0.; iter < MAX_ITER; iter++) {		
		float xt = x*x - y*y + cx; 
		float yt = 2. * x * y +cy; 
		x = xt; 
		y = yt; 
		quad = x*x + y*y; 
		if(quad > MAX_QUAD) {
			return vec2(iter, quad); 
		}
	}
	
	return vec2(MAX_ITER, quad); 
}
 
void main( void ) {
	vec2 d = vec2(-.52, -.52); 
	vec2 p = (( gl_FragCoord.xy / resolution.xy ) - vec2(.75,.5)) * 2.;
	p.x -= (mouse.y * 100.0);
	p *= 1.0 / (mouse.x * 100.0 + 1.0);
	
	if(abs(p.x) < 0.001 || abs(p.y) < 0.003) {
		gl_FragColor = vec4(1.0,0.0,0.0,1.0); 
		return; 
	}
	
	if(abs(d.x - p.x) < 0.005 || abs(d.y - p.y) < 0.005) {
		gl_FragColor = vec4(0.0,1.0,0.0,1.0); 
		return; 
	}
	
	const float MAX = 55.; 
	
	vec2 z = point(p.x, p.y); 
	float i = z.x; 
	float q = z.y; 
	
	
	
	gl_FragColor = (i == MAX_ITER) ? vec4(q) : vec4(i / MAX_ITER); 
}