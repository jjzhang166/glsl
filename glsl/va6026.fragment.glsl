// Mouse X: undershoot / overshoot 
// Mouse Y: sphere radius

// 3D newton fractal by Kabuto

// This is like the ordinary complex plane newton fractals except that this one uses 3 dimensions instead of 2.
// So what you see is a cross plane section through the entire fractal.
// It uses the 3 corners of a tetrahedron as attractors.

// Math background: The usual complex plane newton fractals seek nulls in complex functions.
// Example: f(x) = x³-1
// Newton step: x := x - f(x) / f'(x)
//
// An alternate approach: searching a null on the terrain defined by the function f(x,y) = |(x+y*sqrt(-1))³-1|
// and using the modified newton step (x,y) := (x,y) - f(x,y) * f'(x,y) / |f'(x,y)|²
// (note that f'(x,y) yields a vector by differentiating each coordinate separately)
//
// Interestingly, the result is exactly the same.
// Also, since the second approach operates on vectors instead of complex numbers it's easy to extend that one
// to more than 2 dimensions. That's what you're seeing here.
//
// Programmed using maxima and lots of curses about those crappy shader compilers

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Returns a vec4 containing the found 3D point in xyz and the number of iterations it took in w
vec4 newton(vec3 v) {
	float d = 0.0;
	for(int i = 0; i < 32; i++){
		d += 1.0;
		vec3 a = abs(v)-1.0;
		if (v.x*v.y*v.z > 0.0 && dot(a,a) < 0.1) {
			return vec4(sign(v), d+2.5*length(a));
		}
		float r = dot(v,v);
		float q = (16.0*r*r*r - 32.0*r*r + 16.0*r + 256.0*v.x*v.y*v.z);
		vec3 v2 = 4.0*v*r*r-(32.0*v.yzx*v.zxy+24.0*v)*r-96.0*v.yzx*v.zxy+64.0*v*v*v+36.0*v;
		v -= (v*.25 + v2/q)*(2.*mouse.x+.2);
	}
	
	return vec4(0.0,0.0,0.0,64.0);
}


vec3 pixel(float x, float y2) {
	float a2 = time;
	vec3 vx = vec3(1,0,0);
	vec3 vy = vec3(0,cos(a2),-sin(a2));
	vec3 vz = vec3(0,sin(a2),cos(a2));
	
	vec3 w = x*vx+y2*vy*1.4+0.*vz;
	
	float d = 0.;
	vec3 vd = normalize(vz+vy);
	// |w+vd*d| = r -> w²+vd²*d²+2*w*vd*d = r² -> d = (-w*vd+/-sqrt((w*vd)²-w²+r²))
	float wvd = dot(w,vd);
	
	float det = wvd*wvd-dot(w,w)+100.*mouse.y*mouse.y;
	if (det < 0.) return vec3(0.);
	float s = sqrt(det);
	d = -wvd-s;
	vec4 vt = newton(w+vd*d);
	vec4 vn = vt;
	for (int i = 1; i < 30; i++) {
		float q = (0.4+0.8*fract(fract(x*61.617+w.z)*fract(w.y*45.141+0.1234)*fract(float(i)*0.354+0.3562541+time)*172635.7621))/(1.0+vn.w);
		d += .05*q*float(10+i)*1.4;
		vn = newton(w+vd*d);
		if (dot(vt.xyz,vn.xyz) < 0. || d > s-wvd) break;
	}
	vec4 v = vt;
	return (vec3(0.5)+v.xyz*0.5*(1.0-(v.w/64.0)))/(1.+d+wvd+s);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	gl_FragColor = vec4(pixel(
		(gl_FragCoord.x/resolution.x - 0.5)*15.0,
		(gl_FragCoord.y-resolution.y*0.5)/resolution.x*15.0
	), 1.0 );
}