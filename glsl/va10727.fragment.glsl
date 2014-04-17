#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float s; 

void main( void )
{	
	vec2 a1 = vec2(200.,150.);
	vec2 a2 = mouse*resolution.xy;
	vec2 a3 = vec2(600.,200.);

	float ma = (a2.y-a1.y)/(a2.x-a1.x);
	float mb = (a3.y-a2.y)/(a3.x-a2.x);
	float x = (ma*mb*(a1.y-a3.y)+mb*(a1.x+a2.x)-ma*(a2.x+a3.x))/2./(mb-ma);
	float y = ((a1.x+a2.x)/2.-x)/ma+(a1.y+a2.y)/2.;	
	float rad = distance(a1,vec2(x,y));
	s = abs(pow(gl_FragCoord.x - x,2.) + pow(gl_FragCoord.y - y,2.) - rad*rad);
	float a = (a3.y-a1.y), b = a1.x-a3.x;
	float d = (a*gl_FragCoord.x+b*gl_FragCoord.y+a1.x*(a1.y-a3.y)+a1.y*(a3.x-a1.x))/sqrt(a*a+b*b);
	float dmouse = (a*a2.x+b*a2.y+a1.x*(a1.y-a3.y)+a1.y*(a3.x-a1.x))/sqrt(a*a+b*b);
	if (dmouse < 0. && d > 0. || dmouse > 0. && d < 0.) 
		s = 10000.;
	gl_FragColor = vec4(1000./s, 0.0, 0.5, 1.);
}