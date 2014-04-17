#ifdef GL_ES
precision mediump float;
#endif
#define ITERATIONS 1000

varying vec2 surfacePosition;
const vec2 scale=vec2(2,2);
const vec2 offset=vec2(-0.5,0.0);

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
	position*=scale;
	position+=offset;
	int its=checkMandelbrot(position);
	
	float r=0.2+float(its)/20.0;
	if (r>1.0)
	{
		r-=float(int(r));
		r+=0.2;
	}
	if (its<ITERATIONS)
		gl_FragColor = vec4(r,0.0,0.0,1 );
	else
		gl_FragColor = vec4(vec3(0),1);

}