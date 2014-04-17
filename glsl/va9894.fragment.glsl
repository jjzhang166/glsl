#ifdef GL_ES
precision mediump float;
#endif

//public domain

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI  4.*atan(1.) 
#define TAU 2.*PI

//global vars
vec2 uv;
vec2 m;

//functions
float circle(vec2 p, float r);
float sdfLine(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);

void main( void ) {	
	
	//since the screen is probably wider than it is tall, we find the smaller of the two and use that so we get 1:1 xy coordinates for the math (else drawing a circle would be squished)
	float maxRes = max(resolution.x, resolution.y);
	vec2 aspect = resolution.xy/maxRes;
	float scale = 8.;
	uv = scale * (gl_FragCoord.xy/maxRes); 
	uv = uv - vec2(scale*.5) * aspect;
	

	vec2 dir = vec2(1.);normalize(mouse-.5);
	
	float t = 3.;
	dir *= vec2(sin(t * time), cos(t * time));
	
	
	vec2 xAmount 		= vec2(dir.x, 0.); 
	vec2 yAmount 		= vec2(0., dir.y); 
	
	float xLine 		= line(vec2(0.), xAmount, 0.005);
	float yLine		= line(vec2(0.), yAmount, 0.005);
	float mouseLine		= line(vec2(0.), dir, 	  0.005);
	float hypotenuse	= line(xAmount,  yAmount, 0.005); 
		
	
	//Lines
	vec4 result =vec4(0.);
	result.x 		= xLine;
	result.y		= yLine;
	result.z		= mouseLine;
	result.xy		+= vec2(hypotenuse); 
		
	float r = length(result.xy);
	r = normalize(dot(vec4(r), result));
	
	result *= fract(result*r);
	result *= fract(result*r);
	
	gl_FragColor = result;
}		     		     

float sdfLine(vec2 a, vec2 b){
	float d0,d1,l;
	
	vec2  d = normalize(b - a);
	
	l  = distance(a, b);
	d0 = max(abs(dot(uv - a, vec2(-d.y, d.x))), 0.0),
	d1 = max(abs(dot(uv - a, d) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d0, d1));
}

float line(vec2 a, vec2 b, float w){
	float l = sdfLine(a,b);
	return 1.-l+step(l,w);
}

// sphinx