//-----------------------------------
//-  Singularity Studios Edge Walk  -
//-	 Made by Philip Haynes      -
//-	 for no reason at all       -
//-		Enjoy!              -
//-----------------------------------
// With help from @emackey: pan/zoom
// Might add period 3 bulb rotation as well... ~Singularity
// For reasons I cannot fathom, it's not terminating the iterating
// function when z escapes... Anyone know why? ~Singularity
// Turns out something about using negative numbers makes it
// stop working... huh... Found a workaround ~Singularity

#ifdef GL_ES
precision mediump float;
#endif
#define pi 3.141592

/* better colours and speed -- but hey, that's personal preference
anyways -- wish there was more fractal stuff around here like
this: http://glsl.heroku.com/e#5946.1 but animated and with zoom */

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec3 lerp(vec3 a, vec3 b, float i)
{
	return a*i+b*(1.-i);
}
float sqr(float a) {
	return a*a;
}

void main( void ) {
	/*float sequence[4];
	sequence[0] = 1.;
	sequence[1] = 1.3125;
	sequence[2] = 1.38125;
	sequence[3] = 1.396825;*/
	vec2 position = surfacePosition * 2.0;
	float speed = .26;
	float realtime = mod(time*speed,6.*pi);
	vec3 color = vec3(0.,0.,0.);
	vec3 c1 = vec3(1.,0.,0.);
	vec3 c2 = vec3(0.,0.,1.);
	vec3 c3 = vec3(0.,.4,0.);
	vec2 c, z, nz;
	float locx, locy;
	float its, its2;
	c = position;
	z = c;
	if(realtime<pi*2.)
	{
		locx = (-(cos(realtime/2.)/2.)+(cos(realtime)/4.));
		locy = -(-(sin(realtime/2.)/2.)+(sin(realtime)/4.));
	}
	else if(realtime>pi*4.)
	{
		locx = (-(cos(pi-realtime/2.)/2.)+(cos(pi*2.-realtime)/4.));
		locy = (-(sin(pi-realtime/2.)/2.)+(sin(pi*2.-realtime)/4.));
	}
	else
	{
		locx = -cos(-realtime)/4.+1.;
		locy = sin(-realtime)/4.;
	}
	//loc.x = -1.396825;
	//loc.y = 0.;
	float leng = pow((sqr(position.x+locx)+sqr(position.y-locy))*16.,.01);
	color+=max(c3-c3*leng,0.)*32.;
	for(int itss = 0; itss < 100; itss+=1)
	{
		nz.x = z.x*z.x-z.y*z.y-locx;
		nz.y = 2.*z.x*z.y+locy;
		z = nz;
		if((sqr(z.x)+sqr(z.y)) >= 4.)
		{
			its = float(itss)-sqrt(sqr(z.x)+sqr(z.y))/2.;
			break;
		}
		else if(itss==99)
		{
			its = sqrt(sqr(z.x)+sqr(z.y))*100.;
		}
	}
	color += c1*its/100.;
	z = c;
	for(int itss = 0; itss < 200; itss+=1)
	{
		nz.x = z.x*z.x-z.y*z.y+c.x;
		nz.y = 2.*z.x*z.y+c.y;
		z = nz;
		if(sqrt(sqr(z.x)+sqr(z.y)) >= 2.)
		{
			its2 = float(itss)-sqrt(sqr(z.x)+sqr(z.y))/2.;
			break;
		}
		else if(itss==199)
		{
			its2 = float(itss);
			its2 = sqrt(sqr(z.x)+sqr(z.y))*200.;
		}
	}
	//color += c2*its2/200.;
	
	gl_FragColor = vec4( color, 1.0 );
}