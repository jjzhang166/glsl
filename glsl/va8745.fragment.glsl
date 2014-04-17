#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a raymarching experiment by kabuto

const int MAXITER = 40;

vec3 field(vec3 p) {
	p *= .1;
	float f = .1;
	for (int i = 0; i < 4; i++) {
		p = p.yzx*mat3(.7,.6,0,-.6,.8,0,0.02,0,0.9);
		p += vec3(.123,.456,.789)*float(0.01*sin(0.5*(1.0-abs(cos(time*0.05)))*time));
		p = abs(fract(p)-.5);
		p *= 2.0;
		f *= 2.1;
	}
	p *= p;
	return sqrt(p+p.yzx)/f-.09;
}

void main( void ) {
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x, 0.3));
	float a = time;
	vec3 pos = vec3(5.0*cos(time*.1), 5.0*sin(time*.1), 5.0*sin(time*.1));
	
	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos);
		float f = min(min(f2.x,f2.y),f2.z);
		
		pos += dir*f;
		color += float(MAXITER-i)/(f2+.01);
	}
	vec3 color3 = vec3(1.-1./(1.+color*(.09/float(MAXITER*MAXITER))));
	color3 *= color3;
	gl_FragColor = vec4(vec3(color3.r+color3.g+color3.b),1.);
}