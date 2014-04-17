#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Ljapunov exponents for newton fractal. Looks familiar, doesn't it? :-) - kabuto

float deriv(vec2 p, vec2 a) {
	float dv = 0.;
	for (int i = 0; i < 100; i++) {
		// 1-a/n-(n-1)/n*x^-n
		// pd = 1-a/3-2/3*a*p^-3
		// pd = 1-a/2-1/2*a*p^-2
		
		float l = dot(p,p);
		
		vec2 p3 = vec2(p.x*p.x-p.y*p.y,-2.*p.x*p.y)/(2.*l*l);

		vec2 pd = vec2(1,0)-a/2.-vec2(p3.x*a.x-p3.y*a.y,p3.x*a.y+p3.y*a.x);
		dv += log(length(pd));

		vec2 d = p-vec2(p.x,-p.y)/l;
		p -= vec2(d.x*a.x-d.y*a.y,d.x*a.y+d.y*a.x)/2.;
	}
	return dv;
}

vec2 newton(vec2 p, vec2 a) {
	for (int i = 0; i < 100; i++) {
		// Modified newton function: x := x-a*f(x)/f'(x) (a is a factor to make the newton function miss its target a bit)
		// For f(x) = x^n-1 this yields: x := x-a*(x-x^(1-n))/n
		// p := p-(p-1/p^2)*a/3
		// p := p-(p-1/p)*a/2
		float l = dot(p,p);
		vec2 d = p-vec2(p.x,-p.y)/l;
		p -= vec2(d.x*a.x-d.y*a.y,d.x*a.y+d.y*a.x)/2.;
	}
	return p;
}
void main( void ) {

	//vec2 p = ( gl_FragCoord.xy - resolution.xy*.5 )*5./resolution.x;
	float dv = 0.;
	
	vec2 sc = gl_FragCoord.xy / resolution*vec2(2,1);
	vec2 m = fract(mouse*vec2(2,1));	


	if (gl_FragCoord.x < resolution.x*.5) {
	
		float grey = atan(deriv(m*4.2-2.1,fract(sc) *4.2+vec2(0.,-2.1))*.05)/3.14159265359+.5;
		gl_FragColor = vec4(grey);
	} else {
		vec2 p = newton(fract(sc)*4.2-2.1,m *4.2+vec2(0.,-2.1));
	
	
		float angle = atan(p.y,p.x);
		float amp = atan(length(p))*2./3.14159265359;
	
		vec3 color = vec3(cos(angle),cos(angle+2.1),cos(angle-2.1));
	
	
		
		gl_FragColor = vec4(vec3(amp)+color*amp*(1.-amp),1.);
	}
	//gl_FragColor=vec4(0);

}