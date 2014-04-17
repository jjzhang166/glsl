#ifdef GL_ES
precision mediump float;
#endif

// cubic bezier curve evaluation
// based on the quadratic bezier curve evaluation as discussed here:
// http://www.pouet.net/topic.php?which=9119&page=2


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;




// Tries to solve a quintic function (http://en.wikipedia.org/wiki/Quintic_function).
// When function f(t) = aa*t^5 + bb*t^4 + cc*t^3 + dd*t^2 + ee*t + ff
// then this function will return a value of t for which f(t) = 0

float solveQuintic(in float aa, in float bb, in float cc, in float dd, in float ee, in float ff)
{
	float epsilon = 0.0001;
	
	float x = 0.5; // initial guess...
	
	const int maxSteps = 62;
	const float maxStepsF = float(maxSteps);
		
	for (int i=0; i<maxSteps; ++i)
	{
		// Calculate f(x), f'(x) and f''(x)
		
		float fx =       aa*x*x*x*x*x +   bb*x*x*x*x +   cc*x*x*x +   dd*x*x + ee*x + ff;
		float fx1 =  5.0*aa*x*x*x*x + 4.0*bb*x*x*x + 3.0*cc*x*x + 2.0*dd*x +   ee;
		float fx2 = 20.0*aa*x*x*x +  12.0*bb*x*x +   6.0*cc*x +   2.0*dd;
		
		if (abs(fx) <= epsilon)
			return x;
		
		float G = fx1 / fx;
		float H = G*G - (fx2 / fx);
		
		float aDiv = sqrt( (maxStepsF-1.0)*(maxStepsF*H - G*G) );		
		float aDenom = (abs(G + aDiv) > abs(G - aDiv)) ? (G+aDiv) : (G-aDiv);
		
		float a = maxStepsF / aDenom;
		
		// If our required step becomes too small, we'll consider it a hit too.
		if (abs(a) < 0.000001)
			return x;
		
		x = x - a;
	}
	
	return x;
}


float DistanceToCubicSpline(in vec2 p0, in vec2 p1, in vec2 p2, in vec2 p3, in vec2 x)
{
	// Coeffs for a simple 4-point cubic spline. Any point p(t) on the spline can then be
	// calculated like this:
	//    p(t) = a*t^3 + b*t^2 + c*t + d
	// with t in [0, 1]
	
	vec2 a = 3.0*(p1 - p2) + (p3 - p0);
	vec2 b = 3.0*(p0 + p2 - 2.0*p1);
	vec2 c = 3.0*(p1 - p0);
	vec2 d = p0;
	
	// The time t of the point p(t) on the curve that's closest to our given point x can
	// be found by taking the squared distance function from x to p(t):
	//
	// d = ( x - p(t) )^2
	//
	// this distance has a minimum when the derivative d' equals zero!
	//
	// d' is:
	//
	// t^5 * (6*a^2) +
	// t^4 * (10*a*b) +
	// t^3 * (8*a*c + 4*b^2) +
	// t^2 * 6*(a(d-x) + b*c) +
	// t * (4*b*(d-x) + 2*c^2) +
	// 2 * c*(d-x)
	
	// ïn short:
	// d'(t) = da*t^5 + db*t^4 + dc*t^3 + dd*t^2 + de*t + df
	
	float derA = 6.0*dot(a,a);
	float derB = 10.0*dot(a, b);
	float derC = 8.0*dot(a, c) + 4.0*dot(b,b);
	float derD = 6.0*(dot(a, d-x) + dot(b, c));
	float derE = 4.0*dot(b, (d-x)) + 2.0*dot(c, c);
	float derF = dot(c, d-x);
	
	// Solve quintic. Will return t for which d' equals zero.
	float t = solveQuintic(derA, derB, derC, derD, derE, derF);
	
	// Clamp to curve range.
	t = clamp(t, 0.0, 1.0);

	vec2 nearestPosOnSpline = a*t*t*t + b*t*t + c*t + d;
	
	float dist = length(nearestPosOnSpline - x);
	
	return dist;

/*
	float dis = 1e20;
	
	vec2  sb = (P1 - P0) * 2.0;
	vec2  sc = P0 - P1 * 2.0 + P2;
	vec2  sd = P1 - P0;
	float sA = 1.0 / dot(sc, sc);
	float sB = 3.0 * dot(sd, sc);
	float sC = 2.0 * dot(sd, sd);
	
	vec2  D = P0 - p;

	float a = sA;
	float b = sB;
	float c = sC + dot(D, sc);
	float d = dot(D, sd);

    	float res[3];
	int n = solveCubic(b*a, c*a, d*a, res);

	float t = clamp(res[0],0.0, 1.0);
	vec2 pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p));
	
    	if(n>1) {
	t = clamp(res[1],0.0, 1.0);
	pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p));
	    
	t = clamp(res[2],0.0, 1.0);
	pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p));	    
    	}
    	return dis;
*/

}

void main(void)
{
	vec2 position = gl_FragCoord.xy;
	vec2 p[4];
	
	p[0] = vec2(resolution.x*.40,resolution.y*.4);
	p[1] = vec2(resolution.x*.50,resolution.y*.7);
	p[2] = mouse*resolution;
	p[3] = vec2(resolution.x*.70,resolution.y*.5);
	
	float d = DistanceToCubicSpline(p[0], p[1], p[2], p[3], position);
	
	float lineThickness = 12.0;
	float lineSoftness = 1.0;
	float outline = 1.0;
	d = (d - (lineThickness-1.0)) / lineSoftness;
	//if(outline>0.0) d = abs(d)-outline;
	
	// Curve Control points
	d = min(d, length(p[0] - position)-3.0);	// <-- curve start
	//d = min(d, length(p[1] - position)-3.0);	// <-- curve halfway
	d = min(d, length(p[3] - position)-3.0);	// <-- curve end
	
	d = min(d, length(p[2] - position)-4.0);	// <-- mouse controlled point
	
	d = clamp(d, 0.0, 1.0);
	d = mix(0.8, 0.5, d);
	gl_FragColor = vec4(d,d,d, 1.0);
}



