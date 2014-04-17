#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//due credits:
//glsl.heroku.com/e#5763.3 	//mod noise
//glsl.heroku.com/e#8629.0 	//noise
//glsl.heroku.com/e#10291.13 	//spectrum
//glsl.heroku.com/e#10417.1	//gabor
//glsl.heroku.com/e#10011.0	//gradient functions
//glsl.heroku.com/e#9722.3	//trifold
//<3 to everyone

//basis matching
//
//todo: pixel sample kernel within block
//add more basis functions to test
//cleanup/optimize
//sphinx - in progress

float rand(vec2 co);
float noise(vec2 p, float s);
vec3 fractnoise(vec2 p, float s);
float fractnoise(vec2 p, float s, float c);
float mix2(float a2, float b2, float t2);
float colorBand(float x, float start, float width);
vec3 spectrum(float x);
float gabor(vec2 xy, vec3 f);

void main( void ) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	float modulus = 4.;
	vec2 block = vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));
	
	//Random Seed
	float seed = rand(block+time*.0001);
	seed = floor(seed*256.5)/256.; 	//band
	vec3 randColor = spectrum(seed);
	
	//Linear
	float timestep = fract((time*.1)+time); //fix...
	timestep = floor(timestep*256.5)/256.; 	//band
	vec3 linearColor = spectrum(timestep);
	
	//Gabor
	float g = gabor(block, randColor);
	
	float timer = fract(time * .05);

	//Signal
	//todo: use buffer instead of rerendering
	float noise = length(fractnoise(block + vec2(6.001, 5.0), 725., 1.4));
	noise = fract(.25*noise*modulus);	//block
	noise = floor(noise*256.5)/256.; 	//band
	vec3 signal = spectrum(noise);
	
	//Buffer
	vec4 buffer = texture2D(backbuffer, uv);	
	vec4 result = vec4(buffer);
	
	//Match
	vec3 tolerance = vec3(.0);//05;
	if (buffer.a == 0.){
		result.a = 0.;
	
		if(linearColor == signal){
			result 	=  vec4(.25, 0., 0., 25.);
			result.rgb += signal * .1;
		}
		
		if(randColor == signal){
			result 	=  vec4(0., .25, 0., 1.);
			result.rgb += signal * .1;
		}
	}
	
	//Auto Reset
	if(time < 1. || timer < .001){
		result 	 = vec4(signal, 0.);
		result.a = 0.;
	}
	
	gl_FragColor = result;
	//gl_FragColor = vec4(randColor, 0.);
	//gl_FragColor = vec4(linearColor, 0.);
	//gl_FragColor = vec4(signal, 0.);
	//gl_FragColor = vec4(g);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float s){
      return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
}
 
float mix2(float a2, float b2, float t2)
{ return mix(a2,b2,t2*t2*(3.-2.*t2)); }
	
float fractnoise(vec2 p, float s, float c){
	float sum = .0;
	for(float i=0. ;i<6.; i+=1.){
        
	vec2 pi = vec2(pow(2.,i+c)), fp = fract(p*pi), ip = floor(p*pi);
        	sum += 2.0*pow(.5,i+c)*mix2(mix2(noise(ip, s),noise(ip+vec2(1.,.0), s), fp.x), mix2(noise(ip+vec2(.0,1.), s),noise(ip+vec2(1.,1.), s), fp.x), fp.y);
	}
	
      return sum*(2.2-c);
}
    
vec3 fractnoise(vec2 p, float s){
	vec3 sum = vec3(.0);
	for(float i = .0; i<4.; i+=1.)
	{
		sum += fract(vec3(99.9)*vec3(cos(12.9+s*29.8+i*19.9),cos(14.0+s*17.9+i*23.7),cos(12.1+s*22.1+i*24.5)))*vec3(fractnoise(p, s+i, (i+1.0)));
	}
	return sum;
}

// 2PI
#define COLOR_WIDTH 6.283185307179586
#define BRIGHTNESS -0.3
#define CONTRAST 1.5
float colorBand(float x, float start, float width) {
	return (cos(x * width + start) / 2. + 0.5 + BRIGHTNESS) * CONTRAST;
}

vec3 spectrum(float x) {
	x*= COLOR_WIDTH;
	float r = colorBand(x, 2.0943951023931953, COLOR_WIDTH); // 2PI/3
	float g = colorBand(x, 3.141592653589793, COLOR_WIDTH); // PI
	float b = colorBand(x, 4.1887902047863905, COLOR_WIDTH); // 4PI/3
	return vec3(r, g, b);
}

float gabor(vec2 xy, vec3 f) {
	//vec2 position = ( gl_FragCoord.xy / resolution.xy );
	//todo add rotation
	float n = 20.0 * f.x;
	float phase = f.y;
	float fs = 150.0 * f.z;
	float contr = 1.0;
	float r = 2.0;
	float x = xy.x-0.5;
	float y = -xy.y+0.5;
	float R2 = r*r;
	float m = exp(-0.5*(x*x + y*y/R2)/pow(0.07,2.0));
	float c = m*contr*cos(fs*x - phase);
	//c += (n*(rand(vec2(x,y)+phase)-0.5) + 0.5)/127.5;
	c = (1.0+c)/2.0;
	return c;
}