#ifdef GL_ES
precision mediump float;
#endif

/* Failed attempt at a newton fractal for z^3-1...
 * I don't know why the lines are so wobbly,
 * maybe it's the floating point error that's accumulating in the iterations.
 * IDK
 */


uniform float time;
varying vec2 surfacePosition;
float PI = 3.1415926535897932384626433832795028841971693993751058;

float f(float x)
{
	float y = 0.0;
	if (mod(x, 4.0*PI) < 2.0*PI)
		return (cos(x)-1.0)*0.5;
	else
		return 1.0-cos(x);
}

void main( void ) {
	vec2 p = surfacePosition*pow(10., f(time*0.5)*5.0);
	
	for(int i=0;i<50;i++) {
		
		float d=1./(3.*(p.x*p.x+p.y*p.y)*(p.x*p.x+p.y*p.y));
		p=vec2(p.x + d*(p.x*p.x - p.x*p.x*p.x*p.x*p.x - p.y*p.y - 2.*p.x*p.x*p.x*p.y*p.y*p.y - p.x*p.y*p.y*p.y*p.y),
		       d*2.*p.y*(-p.x + p.x*p.x*p.x*p.x + 2.*p.x*p.x*p.y*p.y + p.y*p.y*p.y*p.y)); // It hurts!
		
		/* What it does: (x+yi)-((x+yi)^3-1)/(3(x+yi)^2) = 
	    	 * (2 y (-x + x^4 + 2 x^2 y^2 + y^4))/(3 (x^2 + y^2)^2) + 
		 * (x + (x^2 - x^5 - y^2 - 2 x^3 y^2 - x y^4)/(3 (x^2 + y^2)^2))i
		 */
		
	}
	
	gl_FragColor = vec4(p.x,p.y,-p.x-p.y,1.0);
}