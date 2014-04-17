#ifdef GL_ES
precision mediump float;
#endif 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

const float linear_a=1.0; 	//slider[0.1,2,1];
const float linear_b=01.8; 	//slider[0.1,2,10];
const float wrap=0.5; 		//slider[0.1,0.5,10]
const float radius=0.81; 	//slider[0.1,1.7,10];
const float scale=2.; 	//slider[6,2,10];
const float angle=180.; 	//slider[0,180,360];
const int iters=15;
const float bailout=50.;	// slider[1,13,1000];

const vec2 box = vec2(wrap,wrap);

// Shabby - non working implementation of the MandelX fractal
// non linear pull not working - ugh!
// Has some nice curves if u play with radius and linears
// got from:
// http://www.fractalforums.com/new-theories-and-research/an-interesting-fractal-the-mandelex-%28inspired-by-the-box%29/


vec2 wrapBox(vec2 p, const vec2 box) 
{
	return clamp(p, -box, box) * 2. - p;
}

void wrapCirc(inout vec2 p, float r) 
{
	float l = length(p);
	if (l>r)
		p=2.*p*r/l-p;
}


vec2 circInvert(vec2 p, const float r) 
{
	float l2 = dot(p,p);
	float r2 = r*r;
	if (l2<r2)
		return p * r2/l2;
	return p;
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

mat2 rotation(const float A)
{
	float cosA = cos(A);
	float sinA = sin(A);
	
	return mat2(cosA, -sinA, sinA, cosA);
}

float mandelx(const vec2 c)
{
	mat2 rot = rotation(angle*3.1415926/180.);
	
	vec2 p = c;
	int k=0;
	for (int a=0;a<iters;a++)
	{
		if (length(p)>bailout)
			break;
		
		linearPull(p,linear_b,linear_b);
		if (abs(c.x)<linear_a && abs(c.y)<linear_a) 
			nonlinearPull(p,linear_a,linear_a);
		p = wrapBox(p,box);
		p = circInvert(p,radius);
		p = rot * p * scale + c;
		linearPull(p,linear_b,linear_b);

		k++;
	}
	return float(k)/float(iters);
}

void main( void ) 
{
	vec2 pos = ( gl_FragCoord.xy / resolution.xy )-0.5 ;
	pos=surfacePosition + vec2(sin(time), cos(time)) * .1;
	
	float v = mandelx(pos);
	v=v*v*v;

	vec3 col = vec3(v,v,v);
	gl_FragColor = vec4( col*vec3(1.,0.4,0)*2., 1.0 );

}