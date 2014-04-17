#ifdef GL_ES
precision mediump float;
#endif 

//(in progress)
//little tutorial for some friends wanting to learn a little about shader math and normalize
//my math isnt so great, so please point out any errors

//converting to 3D in progress...

//todo: clean up, make better line function, make clearer 

//public domain

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI  4.*atan(1.) 
#define TAU 2.*PI

//global vars
vec2 uv;

//functions
float circle(vec2 p, float r);
float sdfLine(vec2 a, vec2 b, float w);
float line(vec2 a, vec2 b, float w);
float box(vec2 p, vec2 s);
vec4 rayMarch(vec3 v);
float dist( vec3 v );

void main( void ) {	
	//Coordinates
	//since the screen is probably wider than it is tall, we find the smaller of the two and use that so we get 1:1 xy coordinates for the math (else drawing a circle would be squished)
	float maxRes = max(resolution.x, resolution.y);
	vec2 aspect = resolution.xy/maxRes;
	
	uv = 4. * (gl_FragCoord.xy/maxRes); // lets multiply it times 8 too, just to scale things
	uv = uv - vec2(2.) * aspect;	
	
	//Input
	//first subtract -.5 so the mouse values are -.5 to .5, then normalize it so the values both alwasy add up to 1. - this gives you a "unit vector"
	vec2 dir 	= normalize(mouse-.5);
	
	//As dir x gets bigger, dir y gets smaller, so they always add up to 1.
	vec2 xAmount 		= vec2(dir.x, 0.);
	vec2 yAmount 		= vec2(0., dir.y); 
	
	float w 		= .5;
	float xLine 		= sdfLine(vec2(0.), xAmount, w);
	float yLine		= sdfLine(vec2(0.), yAmount, w);
	float mouseLine		= sdfLine(vec2(0.), dir,     w);
	float hypotenuse	= sdfLine(xAmount,  yAmount, w); //oh hey, the hypotenuse - the sin and cos stuff is still happening, see?
	
	//Waves
	w = .5;
	float cosLine		= sdfLine(vec2(sin(PI*uv.y), clamp(uv.y, -1., 1.)), vec2(0., yAmount.y), w);
	float sinLine		= sdfLine(vec2(clamp(uv.x, -1., 1.), cos(PI*uv.x)), vec2(xAmount.x, 0.), w);
	float circle		= sdfLine(normalize(uv), dir, w);
		
	//Lines
	vec4 result =vec4(0.);
	result.x 		+= xLine;
	result.y		+= yLine;
	result.z		+= mouseLine;
	result.xy		+= vec2(hypotenuse); 
		
	
	//Waves and a little animation
	result.xz 		+= sinLine * abs(cos(PI + time * .25));
	result.yz 		+= cosLine * abs(cos(.5 * PI + time * .25));
	result.xyz 		+= .25 * circle * abs(cos(time * .1));
	
	
	//Color Boxes
	vec2 bp = aspect;
	bp.x += .4;
	float br = box(bp, vec2(4.)) * dir.x;
	bp.y -= .4;
	float bg = box(bp, vec2(4.)) * dir.y;
	bp.y -= .4;
	float bb = box(bp, vec2(4.));
	bp.y -= .4;
	float ba = box(bp, vec2(4.)) * sqrt(dot(dir, dir))/length(dir);
	
	vec4 b = vec4(br, bg, bb, 0.) + ba;

	vec3 offset = vec3(mouse.x, mouse.y, -.5);
	
	//raytracing result 
	//todo; convert to array, send array rather than marching repeatedly
	vec4 rm, rm0, rm1, rm2, rm3, rm4, rm5, rm6;
	rm0 = rayMarch(vec3(xLine));
	rm1 = rayMarch(vec3(yLine));
	rm2 = rayMarch(vec3(mouseLine));
	rm3 = rayMarch(vec3(hypotenuse));
	rm4 = rayMarch(vec3(cosLine));
	rm5 = rayMarch(vec3(sinLine));
	rm6 = rayMarch(vec3(circle));
	
	rm = 3. * max(max(max(max(rm0, rm1), max(rm2, rm3)), max(rm4, rm5)), rm6);
	
	vec4 color = .75 + normalize(pow(result, vec4(2.)) * -rm);
	
	gl_FragColor =  color * rm + b ;
}		     		     

float sdfLine(vec2 a, vec2 b, float w){
	float d0,d1,l;
	
	vec2  d = normalize(b - a);
	
	l  = distance(a, b);
	d0 = max(abs(dot(uv - a, vec2(-d.y, d.x))), 0.0),
	d1 = max(abs(dot(uv - a, d) - l * 0.5) - l * 0.5, 0.0);
	
	d0 = clamp(d0, 0., 1.);
	d1 = clamp(d1, 0., 1.);
	
	return pow(length(vec2(d0, d1)), w);
}

float line(vec2 a, vec2 b, float w){
	float l = sdfLine(a,b,w);
	return step(l,w);
}

float box(vec2 p, vec2 s){
	vec2 t = uv*s-p*s;
				 
	float b = 0.;			 
	
	b = (t.x > 0. && t.y > 0.) && (t.x < 1. && t.y < 1.) ? 1. : 0.;
	
	return b;
}

//retyped from: http://glsl.heroku.com/e#9766.0
#define M 32
vec4 rayMarch(vec3 v){
	vec3 dir = normalize(vec3( (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 2.0, 1.0));
	
	v.z += 1.;
	
	vec3 pos = vec3(0.0, 0.0, -1.5);
	
	float t = 1.;
	
	int j = 0;
	for ( int i = 0; i < M; i++ ){
		
		float d = length(pos + dir * t);
		float f = float(M-i) / float(M);
		
		float h = length(v);
		
		if ( h < .0001 ){
			return clamp(f-h / ( vec4( float(M-i) / float(M) )), 0., 1.);
		}
		
		v *= f-v*1.04;
	}
	
	return vec4( 0.0 );
}
// sphinx