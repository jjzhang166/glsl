precision highp float;
#define MAX_ITER 128

uniform float time;
uniform vec2 resolution;

void main()
{
	int x2;
	vec2 z = vec2(abs(1.0/1.0+(sin(time * 0.05)))/2.0);
	vec2 temp;
	vec2 p=gl_FragCoord.xy;
	p/=resolution;
	for(int x=0;x<MAX_ITER;x++) {
		x2=x;
		if(length(z.xy) > 2.0) break;
		temp.x = z.x*z.x - z.y*z.y + p.x*5.0-2.5;
		temp.y = 2.0*z.x*z.y + p.y*3.0-1.5;
		z = temp;
	}
	float c = sqrt(float(x2)/normalize(float(MAX_ITER)));
	if (c > 10.0) {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		gl_FragColor = vec4(mod(1.0 - cos(time), 2.0), mod(abs(sin(c + time)), 2.0), mod(1.0 - cos(c + time), 2.0), 1.0);
	}	
}