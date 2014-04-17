#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
float PI = 3.14159265358979323846264;
vec2 origin=vec2(-2,-1.2);
float scale=0.008;
const int maxiter=1000;

float sinn(float a)
{
	return sin(a)/2.0+0.5;
}

float cmandel(void)
{

	int col=0;
	vec2 c = scale*gl_FragCoord.xy+origin;
	vec2 z = vec2(0.0,0.0);
	for (int i=0; i<maxiter; i++) {
		z=vec2(z.x*z.x-z.y*z.y,2.0*z.x*z.y)+c;
		if (length(z)>2.0) {
			col=maxiter-i;
			break;
		}
	}
	return float(col)/float(maxiter);
}

void main( void ) {
	float angle=cmandel();
	if (angle==0.0) {
		gl_FragColor=vec4(0,0,0,1);
	} else {
		angle=angle*2.0*PI;
		gl_FragColor = vec4( vec3(sinn(angle-(3.0*PI/2.0)+time),sinn(angle+time), sinn(angle+(3.0*PI/2.0)+time)), 1.0 );
	}
}