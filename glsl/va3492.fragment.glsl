//Plane stuff
//By: Flyguy

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define HALFPI 1.570795

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool plane(vec2 p1,vec2 p2,vec2 pos);
bool triangle(vec2 p1,vec2 p2,vec2 p3,vec2 pos);
bool line(vec2 p1,vec2 p2,float w,vec2 pos);

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    	return res;
}

float fbm( vec2 p )
{
    	float f = 0.0;
    	f += 0.50000*noise( p ); p = m*p*2.02;
    	f += 0.25000*noise( p ); p = m*p*2.03;
    	f += 0.12500*noise( p ); p = m*p*2.01;
    	f += 0.06250*noise( p ); p = m*p*2.04;
    	f += 0.03125*noise( p );
    	return f/0.984375;
}

void main( void ) {
	
	vec2 c = resolution/2.0;

	vec2 position = ( gl_FragCoord.xy );

	vec3 col;
	
	vec2 cst = vec2(cos(time),sin(time));
	vec2 cst2 = vec2(cos(time+HALFPI),sin(time+HALFPI));
	
	if(triangle(c,c+cst*256.0,c+cst2*256.0,position)) col = vec3(1.0);
	
	if(line(c,c+cst*256.0,1.5,position) || line(c,c+cst2*256.0,1.5,position) || line(c+cst*256.0,c+cst2*256.0,1.5,position)) col = vec3(1.0,0.0,0.0);	
		
	gl_FragColor = vec4( col, 1.0 );
}

bool plane(vec2 p1,vec2 p2,vec2 pos)
{	
	if(p2.x==p1.x) return (pos.x < p1.x);
	
	float slope = (p2.y-p1.y)/(p2.x-p1.x);
	
	float yint = p1.y-slope*p1.x;
	
	return (pos.y < slope*pos.x+yint);
}

bool triangle(vec2 p1,vec2 p2,vec2 p3,vec2 pos)
{
	vec2 mid = (p1+p2+p3)/3.0;
	
	//Used to check if pos is on the inner side of a plane.
	
	bool ab = plane(p1,p2,mid);
	
	bool bc = plane(p2,p3,mid);
	
	bool ca = plane(p3,p1,mid);
	
	return ( (plane(p1,p2,pos)==ab) && (plane(p2,p3,pos)==bc) && (plane(p3,p1,pos)==ca) );
}

//Probably not the best way of doing this.
bool line(vec2 p1,vec2 p2,float w,vec2 pos)
{
	float ang = atan((p2.x-p1.x)/(p2.y-p1.y))+PI;
	vec2 lcossin = vec2(cos(-ang)*w,sin(-ang)*w);	
	
	return triangle(p1-lcossin,p2-lcossin,p2+lcossin,pos)||triangle(p2+lcossin,p1-lcossin,p1+lcossin,pos);
}