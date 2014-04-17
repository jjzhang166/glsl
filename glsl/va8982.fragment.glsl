#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.14159;

vec3 normal(vec2 ang)
{
	return vec3(sin(ang.x)*cos(ang.y), sin(ang.y), -cos(ang.x)*cos(ang.y));
}

struct Plane
{
	vec3 n;
	float d;
};

Plane nPlane(vec3 v,vec3 n, float d)
{
	Plane p;
	p.n = n;
	p.d = dot(v,n)*(1./d);
	
	return p;
}

Plane minP(Plane p1,Plane p2)
{
	if(p1.d < p2.d)
	{
		return p1;
	}
	return p2;
}

struct Hit
{
	vec3 p;
	vec3 n;
};

vec3 rotate(vec3 v,vec2 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	
	
	return (v*rxmat)*rymat;
	
}

Hit scene(vec3 v)
{	
	Plane p;
	
	p = minP(nPlane(v,vec3(0,-1,0),1.0),nPlane(v,vec3(0,1,0),1.0));
	
	for(float i = 0.;i < 12.;i++)
	{
		for(float j = 0.;j < 12.;j++)
		{
			float ax = ((2.*pi)/12.)*j;
			float ay = ((2.*pi)/12.)*i;
			p = minP(p,nPlane(v,normal(vec2(ax,ay)),1.0));
		}
		
	}
	
	return Hit(v/p.d,p.n);
}



void main( void ) {

	vec2 res = vec2(resolution.x/resolution.y,1.0);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);
	
	vec2 m = (mouse-0.5)*pi*vec2(2.,1.);
	
	vec3 color;
	
	vec3 cvec = rotate(vec3(p,0.5),vec2(m));
	
	Hit sc = scene(cvec);
	
	color = vec3(dot(normal(m),sc.n));
		
	gl_FragColor = vec4(  color , 1.0 );

}