#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAXITER = 50;

vec3 field(vec3 p) {
	p = abs(fract(p*p-2.*p)-.5);
	p=p-atan(p)/1.015; // right brain neon loom mod - if everything else fails always try atan :P		
	return sqrt(p*p*p-p.xyy)-.01;
}

void main( void ) {
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));
	float a = time * 0.1;
	vec3 pos = vec3(-2.0*cos(time*0.1),sin(time*0.2)*0.25,time*5.);

	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos);
		float f = max(max(f2.x,f2.y),f2.z);
		
		pos += dir*f;
		color += float(MAXITER-i)/(f2+.01);
	}
	vec3 color3 = vec3(1.-1./(1.+color*(.09/float(MAXITER*MAXITER))));
	vec3 color4 = vec3(1.-1./(1.+color*(.09/float(MAXITER*MAXITER))));
	color3 *= color3;
	vec3 fc=vec3(color3.r+color3.b+color3.b,   color3.b+color3.b+color3.b,   color3.r+color3.r+color3.r);
	fc=(fc-normalize(fc)*0.6)*0.75;
	gl_FragColor = vec4(fc,1.);
}