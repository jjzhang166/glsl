#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define ITER 16

float escRadius=100.0;
float ratio=resolution.x/resolution.y;

vec4 julia(vec2 z,vec2 c){	
	float x,y;
	float iNorm;
	float zAbs;
	int iter;
	for(int i=0;i<ITER;i++){
		x=(z.x*z.x-z.y*z.y)+c.x;
		y=(z.y*z.x+z.x*z.y)+c.y;
		z.x=x;
		z.y=y;
		iter++;
		if((x*x+y*y)>escRadius)break;
	}
	zAbs=sqrt(x*x+y*y);
	iNorm=float(iter+1)-log(log(zAbs))/log(2.0);
	iNorm=1.0/iNorm;
	return vec4(iNorm);
}

void main( void ) {
	vec4 c;
	vec2 z=vec2(gl_FragCoord.xy.x/resolution.x*ratio,gl_FragCoord.xy.y/resolution.y);
	z-=vec2(0.5*ratio,0.5);
	z*=3.0;
	c=julia(z,mouse*2.0-1.5);
	gl_FragColor = smoothstep(0.0,0.15,c);

}