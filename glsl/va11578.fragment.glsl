//GLSL adaptation of rock paper scissors cellular automaton by JRM


#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;


float mmin(float x, float y){
	if(x <= y)
		return x;
	return y;
}

float msin(float x){
return 0.5+0.5*sin(x);
}

//interesting path through rgb color space
vec4 color(float n, float maxIt){
    float r = msin(1.5*n + 0.1)*(0.2+0.5);
    float g = msin(-1.9*n+ .2)*(0.2+0.7);
    float b = msin(5.9*n+3.)*(0.2+0.7);
    return vec4(r,g,b,1);
}

//complex to real power
vec2 cpow(vec2 z, float n){
     vec2 c;
     float mag = pow(sqrt(z.x*z.x + z.y*z.y),n);
     float deg = n * atan(z.y,z.x);
     c.x = cos(deg)*mag;
     c.y = sin(deg)*mag;
     return c;
}

//ln of complex
vec2 cln(vec2 z){
    return vec2(log(z.x*z.x+z.y*z.y)*0.5, atan(z.y,z.x));
}

//e ^ complex
vec2 cexp(vec2 z){
    float ep = pow(2.718281,z.x);
    return vec2(ep*cos(z.y), ep*sin(z.y));
}

//multiply complex #
vec2 cmult(vec2 a, vec2 b){
    return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);
}

//divide complex #
vec2 cdiv(vec2 a, vec2 b){
    float v = b.x*b.x + b.y*b.y;
    return vec2((a.x*b.x+a.y*b.y),(-a.x*b.y+a.y*b.x))/v;
}


void main(void) {
	float min = 10e10;
	vec2 c = 3.5*(gl_FragCoord.xy - resolution.xy/2. - vec2(resolution.x/7000.2,0.)) / resolution.x;
	vec2 z = c;
	float maxIt = 50.;
	float nn;
	for (float n = 0.; n < 25.; n++) {
	nn = n;
		
        if(z.x*z.x+z.y*z.y > 4.)
            break;

	//z = z^2 + c
        z = cpow(z,2.)+c;
		
	//orbit trapping
	vec2 d = z-c;
        float mag = mmin(abs(d.x), abs(d.y));
        mag = mmin(mag,abs(0.01 - abs((z.x*z.x+z.y*z.y))));
        if (mag < min)
        	min = mag;
	}
	
	//smoothing
	if(nn < maxIt)
		nn = nn + 1. - log(log(z.y * z.y + z.x * z.x))/log(2.0);
	if(nn == maxIt - 1.){
		nn = 0.;
	}
	
	// multiply min by 0 to remove orbit trap
    	gl_FragColor = color(nn*min*0.5,maxIt);

}

