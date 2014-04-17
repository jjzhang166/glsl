precision highp float;
#define MAX_ITER 64

uniform float time;
uniform vec2 resolution;

void main()
{
	int x2;
	vec2 z = vec2(0);
	vec2 temp;
	vec2 p=gl_FragCoord.xy;
	p/=resolution;
	for(int x=0;x<MAX_ITER;x++) {
		x2=x;
		if(length(z.xy) > 2.) break;
		temp.x = z.x*z.x - z.y*z.y + p.x*5.0-2.5;
		temp.y = 2.*z.x*z.y + p.y*3.0-1.5;
		z = temp;
	}
	gl_FragColor = vec4(vec3(sqrt(float(x2)/float(MAX_ITER))),1.);
}