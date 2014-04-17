#ifdef GL_ES
precision mediump float;
#endif
#define ITERATIONS 100

varying vec2 surfacePosition;
 

int checkMandelbrot(vec2 p)
{
	float x=0.0;
	float y=0.0;
	for (int it=0;it<ITERATIONS;it++)
	{
		if (x*x+y*y>4.0)
			return it;
		float xtemp=x*x-y*y+p.x;
		y= 2.0*x*y + p.y;
		x=xtemp;
	}
	return ITERATIONS;
}
void main( void ) {

	vec2 position=surfacePosition;
	position.x*=2.0;
	position.y*=2.0;
	position+=vec2(-0.5,0.0);
	int its=checkMandelbrot(position);
	if (its<ITERATIONS)
		gl_FragColor = vec4(its/ITERATIONS,1,1,1 );
	else
		gl_FragColor = vec4(vec3(0),1);

}