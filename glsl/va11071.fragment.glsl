//MG - raymarching
//distance function(s) provided by
//http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define MIN	0.0
#define MAX	30.0
#define DELTA	0.01
#define ITER	200

float sdSphere(vec3 p, float r, float c) {
	p = mod(p,c)-0.5*c;
	return length(p)-r;
}

float castRay(vec3 o,vec3 d) {
	float delta = MAX;
	float t = MIN;
	for (int i = 0;i <= ITER;i += 1) {
		vec3 p = o+d*t;
		
		delta = sdSphere(p,0.6,2.0);
		
		t += delta;
		if (t > MAX) {return MAX;}
		if (delta-DELTA <= 0.0) {return t;}
	}
	return MAX;
}

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*1.0;
	p.x-=resolution.x/resolution.y*0.5;p.y-=0.5;
	vec3 o = vec3(time,0.0,time);
	vec3 d = normalize(vec3(p.x,p.y,1.0));
	
	float t = castRay(o,d);
	vec3 rp = o+d*t;
	
	if (t < MAX) {
		t = 1.0-t/MAX;
		gl_FragColor = vec4(t,t,t,1.0);
	}
	else {
		gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	}
}