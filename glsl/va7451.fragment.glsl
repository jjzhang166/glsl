#ifdef GL_ES
precision mediump float;
#endif
#define ITERATIONS 1000

// using time for rand inspired by e#7439.1 and others

uniform float time;
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
float getColor(int its) {
	float r=0.2+float(its)/20.0;
	if (r>1.0)
	{
		r-=float(int(r));
		r+=0.2;
	}
	return r;
}
vec4 getMandelColor(vec2 position){

	vec4 result = vec4(0.0);
	position*=scale;
	position+=offset;
	
	int its=checkMandelbrot(position);
	
	float c = getColor(its);
	
	if (its<ITERATIONS) {
		float rand = cos(1.0*(0.0015*position.x*position.y*time));
		result = vec4(1.0-c*1.5,c,0.6*c*rand,1 );
	}else
		result = vec4(vec3(0),1);
	return result;
	
}
void main( void ) {
	vec4 final = vec4(0.0);
	vec2 position=surfacePosition;
	final = getMandelColor(position);
	float rand = cos(1.0*(0.0015*position.x*position.y*time));
	final = 0.75*final + 0.5*getMandelColor(position*2.0*fract((0.6*time)*rand*vec2(1.0, 2.0)));		
	gl_FragColor = final;

}