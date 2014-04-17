#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a newton fractal experiment by Kabuto

const int argd1 = 2;
const float argd4 = 3.;

float ff(vec2 z) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	vec2 z3 = vec2(z2.x*z.x-z2.y*z.y,z2.x*z.y+z2.y*z.x);
	    
	vec2 r = z3-vec2(1.,0);
	return dot(r,r);
}

vec3 getLambdaColor (vec2 z, vec2 r) {
    for (int i=0; i < 30; i++) {
	vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
	vec2 z3 = vec2(z2.x*z.x-z2.y*z.y,z2.x*z.y+z2.y*z.x);
	    
	vec2 c = z3-vec2(1.,0);
	vec2 b = 3.*z2;
	vec2 a = 6.*z;
	vec2 p = z;
	    
	// find zeroes for c+b*x+a*x²    
	// -> -b/2a+/-sqrt(b^2-4*a*c)/2a
	vec2 d = vec2(b.x*b.x-b.y*b.y,2.*b.x*b.y)-4.*vec2(a.x*c.x-a.y*c.y,a.x*c.y+a.y*c.x);
	float da = length(d);
	vec2 sq = vec2(sqrt((da+d.x)*.5),sqrt((da-d.x)*.5)*sign(d.y));
	sq = vec2(sq.x*a.x+sq.y*a.y,sq.y*a.x-sq.x*a.y)/dot(a,a)*.5;
	vec2 ct = -vec2(b.x*a.x+b.y*a.y,b.y*a.x-b.x*a.y)/dot(a,a)*.5;
	    
	d = ff(ct+sq)>ff(ct-sq) ? ct+sq : ct-sq;
	z -= vec2(d.x*r.x-d.y*r.y,d.x*r.y+d.y*r.x);
    }
    return vec3(z*.25+.5,.5);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy - resolution*.5) / resolution.y * .5 + vec2(1.,0.);

	gl_FragColor = vec4( getLambdaColor(position, vec2(sin(time*.1)-1., (sin(time*.21)+sin(time*.13)+sin(time*.221))*.6 )), 1.0 );
}
