#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// A secant-based "newton" fractal

const int argd1 = 200;
const float argd4 = 3.;

vec2 f(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	vec2 z3 = vec2(z2.x*z.x-z2.y*z.y,z2.x*z.y+z2.y*z.x);
	vec2 z4 = vec2(z3.x*z.x-z3.y*z.y,z3.x*z.y+z3.y*z.x);
	return z4-vec2(1,0);
}

vec2 fd(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	vec2 z3 = vec2(z2.x*z.x-z2.y*z.y,z2.x*z.y+z2.y*z.x);
	return 4.*z3;
}

vec2 fdd(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	return 12.*z2;
}

vec3 getLambdaColor (vec2 z, vec2 r) {
    for (int i=0; i < 107; i++) {
	vec2 v = f(z);
	vec2 vd = fd(z);
	vec2 vdd = fdd(z);
	    
	vec2 b = 2.*vec2(v.x*vd.x-v.y*vd.y,v.x*vd.y+v.y*vd.x);
	vec2 a = 2.*vec2(vd.x*vd.x-vd.y*vd.y,2.*vd.x*vd.y)-vec2(v.x*vdd.x-v.y*vdd.y,v.x*vdd.y+v.y*vdd.x);

	vec2 d = vec2(b.x*a.x+b.y*a.y,b.y*a.x-b.x*a.y)/dot(a,a);
	d = vec2(d.x*r.x-d.y*r.y,d.x*r.y+d.y*r.x);
	z -= d;

    }
    vec2 s = z;
    return vec3(cos(s.x),cos(s.x+2.1),cos(s.x-2.1))*(sin(s.y)+1.)*.25+.5;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy - resolution*.5) / resolution.y * 3.;

	gl_FragColor = vec4( getLambdaColor(position, (mouse-.5)*4.), 1.0 );
}
