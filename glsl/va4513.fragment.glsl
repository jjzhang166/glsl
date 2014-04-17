precision mediump float;

#define EPSILON 0.1
#define SCREEN_RATIO (resolution.y/resolution.x)
#define PI 3.141592653589

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float maxcomp(vec3 v) {return max(max(v.x, v.y), v.z);}
float udBox( vec3 p, vec3 b ){return length(max(abs(p)-b,0.0));}
float sdBox( in vec3 p, in vec3 b ) {
 	vec3 di = abs(p) - b;
	return min( maxcomp(di), length(max(di,0.0)) );
}

float sphere(vec3 p, float r) { return sqrt(p.x * p.x + p.y * p.y + p.z * p.z) - r; }

float spheres(vec3 p, float r) {
	vec3 c = vec3(1.0,0.0,0.0);
    	vec3 q = mod(p,c)-0.5*c;
    	return sphere( q , r );
}

void rX(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.y = c * q.y - s * q.z;
	p.z = s * q.y + c * q.z;
}

void rY(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.x = c * q.x + s * q.z;
	p.z = -s * q.x + c * q.z;
}

void rZ(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.x = c * q.x - s * q.y;
	p.y = s * q.x + c * q.y;
}

float sdPlane( vec3 p, vec4 n ) {
  return dot(p,n.xyz) + n.w;
}

float f(in vec3 p) {
	p-= vec3(0.0, 5.0, -35.0);
	rX(p, 0.2 * (sin(time*0.6)) - 0.3);
	rY(p, 0.2 * (sin(time*0.5)) );

	float sphere1_r = 10.;
	vec3 sphere1_p = p - vec3(0.0, sphere1_r*2.0 + sin(time)*sphere1_r, 0.0);
	
	float ball = min(sdPlane(p, normalize(vec4(0.0,1.0,0.0,0.0))), sphere(sphere1_p, 10.0));
	return ball;	
}

vec3 nor(vec3 p) {return (vec3(f(p+vec3(0.001,0.,0.)),f(p+vec3(0.,0.001,0.0)),f(p+vec3(0.,0.,0.001)))-f(p))/0.001;}

vec3 mars(inout vec3 p, inout vec3 d, float limit) {
	vec3 start = p;
	float l, iterations;
	iterations = 1.0;
	
	for (float i=0.0;i<128.;i++) {
		l = f(p);
		p += d*l;
		
		
		if (l < 10.) {
			iterations = i;
			break;	
		}
	}
	
	return vec3(l, iterations, length(start-p));
}

float softshadow(vec3 ro, in vec3 rd) {
    float res = 1.0, t = 0.0;
    for( float iter=0.0; iter < 16.; iter+=1.0){
        float h = f(ro + rd*t);
        res = min( res, h/t );
        t += h;
    }
    return res;
}
float rand(vec2 co){return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);}

float ao(in vec3 p, vec3 n) {
	float acc = 0.0;
	for (float i=0.0;i<3.0;i++) {
		vec3 new = normalize(n + 0.3*vec3(rand(p.xy),rand(p.xy),rand(p.xy)));
		for (float u=0.0;u<3.0;u++) acc += f(p+u*new*1.1)*0.022;
	}
	
	return acc;	
		
}

void main() {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 p = vec3(position.x - 0.5, (position.y - 0.5) * SCREEN_RATIO, -1.);
	vec3 d = normalize(p);
	
	float shade = 1.;
	
	p += vec3(0., 10., 100.);
	vec3 col = vec3(0.0);	// background color
	
	vec3 dist = mars(p , d, EPSILON);
	if (dist.x < EPSILON) {
		
		vec3 n = nor(p);
		float lighty = dot(n, vec3(0.5, 1.0, 0.5));
		shade = (1.0 + lighty) * 0.5 + 0.1;	
		shade += p.z * 0.009;
		shade += dist.y * 0.1;
		shade += 0.01*5.0;
		
		p += n * EPSILON;

		float sr = ao(p, n);
		float ss = softshadow(p,n);//1.0;//
	
		col = vec3(ss);//vec3(shade, shade, shade)*0.5 + vec3(0.5*);
	}
	gl_FragColor = vec4( col, 1.0 );
}