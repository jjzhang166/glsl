// Just sit back and let this magical world reveal its secrets...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a raymarching experiment by kabuto


const int MAXITER = 42;


float  tri( float x, float l ){
	return (abs(fract(x/l)-0.5)-0.25)*l;
}
vec3 tri( vec3 p, float l ){
	return vec3( tri(p.x,l), tri(p.y,l), tri(p.z,l) );
}

float factor = sin(time*0.001)*0.5 +1.0;


vec3 field(vec3 p) {
	p *= .1;
	float f = .1;
	for (int i = 0; i < 12; i++) {
		p = p.yzx*mat3(.8,.6,0,-.6,.8,0,0,0,1);
		p += vec3(.123,.456,.789)*float(i);
		p = tri( p, factor/(float(i)+factor) );
	}
	p *= p;
	return sqrt(p+p.yzx)/f-.0002;
}

void main( void ) {
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));
	vec3 pos = vec3(0.51, 0.5,time);
	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos);
		float f = min(min(f2.x,f2.y),f2.z);
		
		pos += dir*f;
		color += float(MAXITER-i)/(f2+.001);
	}
	vec3 color3 = vec3(1.-1./(1.+color*(.09/float(MAXITER*MAXITER))));
	color3 *= color3;
	gl_FragColor = vec4(color3,1.);
}