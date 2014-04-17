#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define ITER 32
#define ITERZ 256

float escRadius=1000.0;
float ratio=resolution.x/resolution.y;

mat4 rotationMatrix(vec3 axis, float angle){
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, 0.0,
		    oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, 0.0,
		    oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c, 0.0,
		    0.0, 0.0, 0.0, 1.0);
}

vec4 julia(vec2 z,vec2 c) {	
	float x=0.0,y=0.0;
	float iNorm;
	float zAbs;
	int iter=0;
	vec4 color=vec4(1.0);
	for(int i=0;i<ITER;i++){
		x=(z.x*z.x-z.y*z.y)+c.x;
		y=(z.y*z.x+z.x*z.y)+c.y;
		z.x=x;
		z.y=y;
		iter++;
		if((x*x+y*y)>escRadius)break;
	}
	#define MUL 0.25
	if(iter<ITER){
		zAbs=sqrt(x*x+y*y);
		iNorm=float(iter+1)-log(log(zAbs))/log(2.0);
		color.r=sin(iNorm*MUL-0.15);
		color.g=sin(iNorm*MUL);
		color.b=sin(iNorm*MUL+0.15);
	}
	return color;
}

void main(void){
	float step=2.0/float(ITERZ);
	vec4 c=vec4(0.0);
	vec4 c1=vec4(0.0);
	vec3 p=vec3(gl_FragCoord.xy.x/resolution.x*ratio,gl_FragCoord.xy.y/resolution.y,0.0);
	vec3 pRot;
	p.xy-=vec2(0.5*ratio,0.5);
	p.z=-1.0;
	p.xy*=3.0;
	float t=cos(time/2.0)*1.000001;
	for(int i=0;i<ITERZ;i++){
		pRot=(vec4(p,1.0)
		      *rotationMatrix(vec3(1.0,0.0,0.0),time/5.0)
		      *rotationMatrix(vec3(0.0,0.0,1.0),time/5.0)		      
		     ).xyz;
		c1=julia(pRot.xy,vec2(pRot.z,5.0*(mouse.y*2.0-1.000001)));
		if(c1.r==1.0)break;
		c+=c1;
		p.z+=step;
	}
	gl_FragColor=smoothstep(0.0,1.00,c/float(ITERZ));
}