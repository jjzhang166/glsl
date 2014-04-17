// 3D newton fractal fog Kabuto

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
vec4 newton(float x, float y, float z) {
	float d = 0.0;
	for(int i = 0; i < 64; i++){
		d += 1.0;
		float xa = abs(x)-1.0;
		float ya = abs(y)-1.0;
		float za = abs(z)-1.0;
		if (x*y*z > 0.0 && xa*xa + ya*ya + za*za < 0.3) {
			return vec4(sign(x), sign(y), sign(z), d+2.5*length(vec3(xa,ya,za)));
		}
		float r = x*x+y*y+z*z;
		float q = (16.0*r*r*r - 32.0*r*r + 16.0*r + 256.0*x*y*z);
		float x2 = 4.0*x*r*r-(32.0*y*z+24.0*x)*r-96.0*y*z+64.0*x*x*x+36.0*x;
		float y2 = 4.0*y*r*r-(32.0*x*z+24.0*y)*r-96.0*x*z+64.0*y*y*y+36.0*y;
		float z2 = 4.0*z*r*r-(32.0*x*y+24.0*z)*r-96.0*x*y+64.0*z*z*z+36.0*z;
		x = x*3.0/4.0 - x2/q;
		y = y*3.0/4.0 - y2/q;
		z = z*3.0/4.0 - z2/q;
	}
	
	return vec4(0.0,0.0,0.0,64.0);
}

float dd = -cos(time*0.1)*1.6+1.4;
vec3 p = vec3(-dd+sin(time*0.3+2.1)*2.0,-dd-sin(time*0.2)*2.0,-dd+sin(time*0.4-2.1)*2.0);
vec3 ps = p;
vec3 dir = -normalize(vec3(-1.0,-1.0,-1.0));
vec3 left = normalize(cross(dir, vec3(0,1.0,0)));
vec3 up = cross(left, dir);

vec3 pixel(float x, float y){
	vec3 d = normalize(dir+left*x+up*y);
	float n = 0.0;
	vec3 r = vec3(0);
	float t = 0.0;
	vec4 nw = newton(p.x, p.y, p.z);
	float it = time+0.15617;
	float q = (0.4+0.8*fract(fract(x*61.617+it)*fract(y*45.141+0.1234)*fract(float(0)*0.354+0.3562541+time)*172635.7621))/(1.0+nw.w);
	p += d*q;
	for (int i = 1; i < 60; i++) {
		vec4 nw = newton(p.x, p.y, p.z);
		float q = (0.4+0.8*fract(fract(x*61.617+it)*fract(y*45.141+0.1234)*fract(float(i)*0.354+0.3562541+time)*172635.7621))/(1.0+nw.w);
		float q2 = q*float(60-i);
		p += d*q;
		r += nw.xyz*q2;
		t += q2;
		it += 0.616343543;
	}
	return sqrt(r/t*0.5+vec3(0.5));
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec3 color = pixel(
		(gl_FragCoord.x/resolution.x - 0.5)*5.0,
		(gl_FragCoord.y-resolution.y*0.5)/resolution.x*5.0
	)*mat3(
		.5,-1,1,
		1,.5,-1,
		-1,1,.5
	)-.5;
	gl_FragColor = (vec4(color+.5, 1.0 ));
}