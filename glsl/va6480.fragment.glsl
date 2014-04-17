// A terrain julia set raymarcher by Kabuto

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec2 CONSTANT =  vec2(-0.835,-0.2321);	// The mandelbrot set point for which to generate the julia set.
//const vec2 CONSTANT = vec2(-0.70176,-0.3842);
//const vec2 CONSTANT = vec2(-0.74543,+0.11301);
const int MAXITER = 50;
const int LOWITER = 10;
const int MAXTRACE = 200;
const float MAXDEPTH = 300.;

// Distance function. Warning: generates bugs for CONSTANT outside the mandelbrot set's features (so the resulting julia set consists of unconnected dots)
float iter(vec4 p, vec4 n4) {
	for(int i=0; i<MAXITER; i++) {
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		if (dot(p.xy,p.xy) > 64.) break;
	}
	float l = length(p.xy);
	float dl = length(p.zw);
	return l<4. ? 0. : l*log(l)/dl;
}
float hash( float n ) {
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x ) {
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+58.0),f.x),f.y);
    	return res;
}

float cloud(vec2 p) {
	float f = 0.0;
    	f += 0.50000*noise(p*1.0); 
    	f += 0.25000*noise(p*2.0); 
    	f += 0.12500*noise(p*4.0); 
    	f += 0.06250*noise(p*8.0);
	return f;
}

void main( void ) {
	vec2 n = (gl_FragCoord.xy-resolution*.5)/resolution.x*mouse.y;
	
	
	// Iterating over the isosurface
	vec4 n4 = vec4(CONSTANT,0,0);
	float amplify = 1.5; // how much to amplify height
	float t = time*.5;
	vec2 pos2 = vec2(cos(t)*.9,sin(t)*.9001);	// Warning: AMD compiler shader bug lingering in here. Specifying the same factor for both (or the entire vec2) will make it fail.
	vec3 pos = vec3(pos2,-cos(2.*t)*.05+.5)-vec3(0,0,-.2);	// Another nasty workaround for another nasty AMD shader compiler bug.
	vec3 dir = normalize(-pos*vec3(1,1,.7)+vec3(0,0,-.2));
	vec3 right = normalize(cross(dir, vec3(0,0,1)));
	vec3 up = cross(dir,right);
	vec3 ray = normalize(dir+right*n.x-up*n.y);
	
	
	float factor = length(ray.xy)/(amplify*length(ray.xy)-ray.z); // correction factor for step distance
	
	float m = 0.;
	float md = 0.;
	
	float steps = float(MAXTRACE);
	for (int i = 0; i < MAXTRACE; i++) {
		m = iter(vec4(pos.xy*mouse.x,1,0),n4)-iter(vec4(pos.y,-pos.x,1,0),n4)*amplify;
		float cutoff = .1;
		float cutoff2 = .3;
		m = m < 0. ? -(1.-1./(1.-m/cutoff2))*cutoff2 : (1.-1./(1.+m/cutoff))*cutoff;
		md = pos.z-m;
		if (md < 1e-4)  {steps = float(i); break;}
		pos += ray*md*factor*.5;
	}
		

	vec3 cb = vec3(30.,4,1)*.01;
	vec3 color = cb/(cb+sqrt(abs(m))*(sign(m)+2.)/3.);//*abs(cos(floor(-m*100.)));
	//color *= (.5+.5*abs(fract(m*100.)));
	float r = (-.03-pos.z)/dir.z;
	vec3 p2 = pos+r*dir;
	float clouds = cloud(p2.xy*50.)*.4*(1.-smoothstep(-.05,-.02,m));;
	
	gl_FragColor = 1.-vec4(color+vec3(1.,.3,.0)*(1.-sqrt((float(MAXTRACE)-steps)/float(MAXTRACE))), 0.0 ) + clouds;

}