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

float LinearGrad(vec2 p1,vec2 p2,vec2 px)
{
	vec2 dir = normalize(p2-p1);
	float g = dot(px-p1,dir)/length(p1-p2);
	return clamp(g,0.,1.);
}

float seed = 0.00001; //Random seed (change for different patterns)
const float nGradients = 115.; //Number of gradients

float Paper(vec2 p)
{
	float c = 0.0;
	
	for(float i = 0.;i < nGradients;i++)
	{
		vec2 p1 = vec2(rand(1.+i+seed),rand(1.1+i+seed))*1000.0;
		vec2 p2 = vec2(rand(1.2+i+seed),rand(1.3+i+seed))*1000.0;
	
		c = abs(c-LinearGrad(p1,p2,p));
	}
	return c;
}

void main( void ) 
{
	vec2 p = ( gl_FragCoord.xy ) + vec2(-300.0, -150.);
	gl_FragColor = vec4(vec3( Paper(p*10.)), 1.0 );
}