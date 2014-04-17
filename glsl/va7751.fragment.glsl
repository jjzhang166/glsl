#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

uniform float res;
uniform float diamondWidth;
uniform float accel;
uniform float patternRes;
uniform float patternFreq;

// modified by @hintz

float lengthN(vec2 v, float n)
{
	float res = 2.5;
	
	vec2 l = pow(abs(v), vec2(n));
	
	return pow(abs(l.x-l.y), res/n);
}
 
float rings(vec2 p)
{	
	float patternRes = 5.0;
	float accel = 1.;
	float diamondWidth = 0.8;
	float patternFreq = 1.0;
	
	return sin(lengthN(mod(p* patternRes, 2.0)-1.0, diamondWidth)* patternFreq *lengthN(p,5.0)+time*accel);
}

void main()
{
	vec2 p = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;;
		
	float c = rings(p);
	
	gl_FragColor = vec4(c,c*c*length(p),-c,1.0);
}