#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a raymarching experiment by kabuto
// dmt fork by s1e


const int MAXITER = 16;

vec3 field(vec3 p, float dime) {
	p *= 0.09;
	float f = .1;
	for (int i = 0; i < 5; i++) {
		p = p.yzx*mat3(.8,.6,0,-.6,.8+0.01*sin(dime/120.0),0, 0.0 + 0.042*sin(dime/25.0), 0.0033 + 0.0012*cos(dime/75.0),1);
		p += vec3(sin(dime/30.0)*0.1 + 0.2, cos(dime/45.0)*0.1 + 0.3, cos(dime/90.0)*0.1 + 0.3)*float(i);
		p = abs(fract(p)-.5);
		p *= 2.0;
		f *= 2.0;
	}
	p *= p;
	return sqrt(p+p.yzx)/f-.002;
}

void main( void ) {
	float dime = time + 10.1;
	
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,0.66));
	vec3 pos = vec3(0, 0, dime/16.0);
	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos, dime);
		float f = min(min(f2.x,f2.y),f2.z);
		
		pos += dir*f;
		color += float(MAXITER-i)/(f2+.000025);
	}
	vec3 color3 = vec3(1.-1.0/(color*(0.00101)));
	color3 = color3 * color3 * color3 * color3;
	gl_FragColor = vec4(color3,1.);
	gl_FragColor *= gl_FragColor;
}