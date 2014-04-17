#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

//Life Sphere
//fork of #9140.3

//Mouse over the bottom left corner to reset.

#define PI 3.14159
#define RGB(r,g,b) vec3(r/255.,g/255.,b/255.)

float scale = 1.;

float get(vec2 p){return 1.-texture2D(bb,mod(p/resolution,1./scale)).a;}

float ne(vec2 p)
{
	return get(p+vec2(0,1))+get(p+vec2(0,-1))+get(p+vec2(-1,0))+get(p+vec2(1,0))+
	       get(p+vec2(-1,-1))+get(p+vec2(-1,1))+get(p+vec2(1,1))+get(p+vec2(1,-1));
}

float life()
{
	vec2 p = gl_FragCoord.xy;
	float c = get(p);
	float n = ne(p);
	
	c = ((n == 2. || n == 3.) && c == 1.) ? c : 0.;
	c = (n == 3.) ? 1. : c;
	
	return c;
}

vec3 rotate(vec3 v,vec2 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	
	
	return v*rxmat*rymat;
	
}

vec3 normal(vec2 a)//normal from yaw/pitch
{
	return vec3(sin(a.x)*cos(a.y), sin(a.y), -cos(a.x)*cos(a.y));
}

vec2 angle(vec3 n) //yaw/pitch from normal
{
	return vec2(atan(n.z,n.x)+PI,atan(n.y,length(n.xz))+PI);
}

vec3 tex(vec2 p,vec3 n)
{
	if(n.z != -1.) //Keep the background from flickering
	{
		return vec3(1.-get(p*resolution/scale)); //Map the previous generation onto the sphere
	}
	return vec3(1);
	
}

vec3 crater(float r, float x, float y,vec2 ang) {
    	float z = sqrt(r*r - x*x - y*y) * 1.5;

    	vec3 normal = normalize(vec3(x, y, z));
	
	normal = rotate(normal,ang);
	
	if(length(vec2(x,y)) > r)
	{
		return vec3(0,0,-1);	
	}
	
	return normal;
}

float rand(vec2 co){
    return floor(fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453)+0.5);
}

void main( void ) {
	vec2 center = resolution / 2.;
	vec2 pos = gl_FragCoord.xy - center;
	float asp = resolution.y;

	vec2 ang = (mouse*2.-1.)*PI*vec2(2.,1.);
	
	vec3 color = vec3(0.);

	
	vec3 n = crater(0.35*asp,pos.x, pos.y,ang);
	
	
	vec3 shade = vec3(dot(n,vec3(0,0.5,0.5)));
	//shade = max(shade,vec3(dot(n,vec3(0,-0.5,-0.5))));
	
	color = tex((angle(n))/vec2(PI*2.,PI*2.),n);
	
	color *= (mix(RGB(106.,88.,135.)*.6,RGB(241.,220.,150.),shade.r));
	
	color = (length(center+pos)<32.)? vec3(0,1,0) : color;
	
	float alpha = (length(mouse*resolution)<32.|| time < 0.5) ? rand(pos+time) : life();
	
	gl_FragColor = vec4(color, 1.-alpha);
}