// Classical interactive Julia fractal rendering of the function x=x^2+c,
// with some documentation of how the calculation is done.
// See http://en.wikipedia.org/wiki/Julia_set for more info.

// By m@bitsnbites, Jan 2013

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Maximum number of iterations (higher number -> slower shader)
const int MAXITER = 100;

// When |p| is beyond this limit, we're heading for infinity (i.e. p0
// is definitely not part of the Fatou set).
const float ESCAPE = 5.0;

float julia(vec2 p, vec2 c) {
	for (int i = MAXITER; i > 0; --i) {
		// Compute p = p^2 + c using complex arithmetic, i.e:
		//  p = x + j*y, p^2 = x^2-y^2 + j*2*x*y
		p = vec2(p.x*p.x-p.y*p.y, 2.0*p.x*p.y) + c;

		// Have we "escaped" (i.e. heading for infinity)?
		float l = length(p);
		if (l > ESCAPE) {
			// Calculate "fractional index", [0,1). This makes the gradient
			// much smoother.
			float fractional = (log(2.0*log(ESCAPE)) - log(log(sqrt(l)))) / log(2.0);
			return (float(i) - fractional) / float(MAXITER);
		}
	}
	return 0.0;
}

vec3 colorJulia(vec2 p, vec2 c) {
	// Perform fractal calculation (this returns a value in the range [0,1])
	float m = julia(p, c);

	// Map the result to an RGB value
	return vec3(m,m*m,sin(3.0*m+time));
}

void main( void )
{
	// The screen coordinate is our iteration starting point
	vec2 p = 1.5*(gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;

	// The mouse coordinate selects the Julia constant
	vec2 c = 4.0*mouse-2.0;

	gl_FragColor = vec4(colorJulia(p, c), 1);
}
