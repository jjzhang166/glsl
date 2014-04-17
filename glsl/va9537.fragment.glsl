#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.14159;

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

vec3 round(vec3 v)
{
	return floor(v+.5);
}

float rand(vec3 co){
    return fract(sin(dot(co.xyz ,vec3(12.9898,78.233,46.4893))) * 43758.5453);
}

float vol(vec3 p)
{
	vec3 mp = round(p*4.);
	float h = abs(sin(mp.z*pi*0.1));
	
	bool sc = (p.y < h-1.)&& (length(mp.xy) > 7.);
	
	return (sc) ? 1. : 0.;
}

vec3 cnorm(vec3 v)
{
	return v/max(max(abs(v.x),abs(v.y)),abs(v.z));
}


float snoise(vec3 v);

const float steps = 180.;
float maxd = 16.;

void main( void ) {

	vec2 res = vec2(resolution.x/resolution.y,1.0);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);
	
	vec2 m = (mouse-0.5)*pi*vec2(2.,1.);
	
	vec3 color = vec3(0.0);
	
	vec3 pos = cnorm(rotate(vec3(p,0.5),vec2(m)));
	
	float dist = 0.0;
	
	for(float i = 0.;i <= steps;i++)
	{
		float d = (i/steps)*maxd; 
		d = sqrt(d*.5);
		
		float shell = vol(pos*d+vec3(0,0,time*.8));
		
		dist = max(dist,shell*(1.-(i/steps)));
	}
	
	color = mix(vec3(1,1,.8),vec3(.2,0,0.1),1.-dist);
		
	gl_FragColor = vec4(  color.xyz , 1.0 );

}