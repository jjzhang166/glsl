#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

// modified by @hintz

float lengthN(vec2 v, float n)
{
	vec2 l = pow(abs(v), vec2(n));
	
	return pow(abs(l.x-l.y), 1.0/n);
}
 
float rings(vec2 p)
{
	return sin(lengthN(mod(p*5.0, 2.0)-2.0, 4.0)*5.0*lengthN(p,1.0)+time*5.0);
}

void main()
{
	vec2 p = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;;
		
	float c = rings(p);
	float c2 = c*c*length(p) * 0.05 + 0.5;
	
	gl_FragColor = vec4(c2,c2,c2,1.0);
}