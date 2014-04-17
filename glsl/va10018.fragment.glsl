#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Wrinkled paper generator
//based off http://www.claudiocc.com/the-1k-notebook-part-iii/

float rand(float n)
{
    vec2 co = vec2(n,0.5-n);
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 LinearGrad(vec2 p1,vec2 p2,vec2 px)
{
	vec2 dir = normalize(p2-p1);
	float g = dot(px-p1,dir)/length(p1-p2);
	return vec3(clamp(g,0.,1.));
}

vec3 Difference(vec3 c1,vec3 c2)
{
	return abs(c1-c2);
}

float seed = 2.41; //Random seed (change for different patterns)
const float nGradients = 15.; //Number of gradients

vec3 Paper(vec2 p)
{
	vec3 c = vec3(0.0);
	
	for(float i = 0.;i < nGradients;i++)
	{
		vec2 p1 = vec2(rand(1.+i+seed),rand(1.1+i+seed))*resolution;
		vec2 p2 = vec2(rand(1.2+i+seed),rand(1.3+i+seed))*resolution;
	
		c = Difference(c,LinearGrad(p1,p2,p));
	}
	return c;
}

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy );
	seed = 32.*mouse.x;
	float h1 = Paper(p).x;
	//float h2 = Paper(p+(vec2(0.005,0.002)*resolution)).x;
	
	vec3 c = vec3( 1.0-(h1));//-h2*.5));
	
	gl_FragColor = vec4(c, 1.0 );
}