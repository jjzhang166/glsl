#ifdef GL_ES
precision mediump float;
#endif 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

float linear_a=1.0; 	//slider[0.1,2,10];
float linear_b=01.8; 	//slider[0.1,2,10];
float wrap=0.5; 		//slider[0.1,0.5,10]
float radius=0.81; 	//slider[0.1,0.5,10];
float scale=2.; 	//slider[1,2,10];
float angle=180.; 	//slider[0,180,360];
const int iters=13;
float bailout=15.;	// slider[1,13,1000];


// Shabby - non working implementation of the MandelX fractal
// non linear pull not working - ugh!
// Has some nice curves if u play with radius and linears
// got from:
// http://www.fractalforums.com/new-theories-and-research/an-interesting-fractal-the-mandelex-%28inspired-by-the-box%29/

void wrapb(inout float a, in float w) 
{
	if (a>w) 
	{
		a=2.*w-a;
	}
	else if (a<-w) 
	{
		a=-2.*w-a;
	};
}

void wrapBox(inout vec2 a, float h, float w) 
{
	wrapb(a.x,w);
	wrapb(a.y,h);
}

void wrapCirc(inout vec2 p, float r) 
{
  float l = length(p);
  vec2 u = p/l;
  if (l>r) 
	  p=2.*r*u-p;
}

void rotate(inout vec2 a, in float phi) 
{
	a = vec2(a.x*cos(phi)-a.y*sin(phi),a.x*sin(phi)+a.y*cos(phi));
}

void absv(inout vec2 a) 
{
	a.x = abs(a.x);
	a.y = abs(a.y);
}

void circInvert(inout vec2 p, in float r) 
{
	float l = length(p);
	if (l<r) p*=r*r/(l*l);
}


void linearPull(inout vec2 p, float h, float w) 
{
	if (abs(p.x)>w && abs(p.y)>h) 
	{
		h*=2.; 
		w*=2.;
		if (p.x<0.) 
			p.x+=h;
			else 
			p.x-=h;
		if (p.y<0.) 
			p.y+=w;
			else 
			p.y-=w;
	}
}

void nonlinearPull( vec2 p, float h, float w) 
{
	if (abs(p.x)>w && abs(p.y)>h) 
	{
		h*=2.; 
		w*=2.;
		if (p.x>0.) 
			p.x-=w*floor(p.x/w);
			else 
			p.x-=w*ceil(p.x/w);
		if (p.y>0.) 
			p.y-=h*floor(p.y/h);
			else 
			p.y-=h*ceil(p.y/h);
	}
	//return p;
}

vec2 formula(vec2 a,vec2 p) 
{
	linearPull(a,linear_b,linear_b);
	if (abs(p.x)<linear_a && abs(p.y)<linear_a) 
		nonlinearPull(a,linear_a,linear_a);
	wrapBox(a,wrap,wrap);
	circInvert(a,radius);
	a*=scale;
	rotate(a,angle/180.*3.1415926);
	a+=p;
	linearPull(a,linear_b,linear_b);
  	return a;
}

vec3 mandelx(vec2 p) 
{
	vec2 c = p;
	int k=0;
	for (int a=0;a<iters;a++)
		{
	//	if (k>=iters) break;
		if (length(p)>bailout) break;
		p = formula(p,c);
		k++;
		}
	float v = float(k)/float(iters);
	v*=v*v;
	return vec3(v,v,v);
}

void main( void ) 
{

	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-0.5 ;
	pos=surfacePosition;
	vec3 col=vec3(0);
	col=mandelx(pos);
	gl_FragColor = vec4( col*vec3(1.,0.4,0)*2., 1.0 );

}