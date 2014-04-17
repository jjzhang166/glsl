#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
vec2 z=(gl_FragCoord.xy/resolution.y-vec2(.5*resolution.x/resolution.y,.5))*4.,p=(mouse-vec2(.5,.5))*4.;

float doiter(vec2 z, vec2 p) {
	for(float f=.5;f<10.;f+=.4){
		if(length(z)>15.9){
			return f-.1*log(log(length(z))/log(2.))/log(2.);
		}
		z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+p;
		z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+p;
		z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+p;
		z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+p;
	}
	return 16.;
}


void main(){
	float d = 0.0001;
	float v = doiter(z,p);
	vec2 dd = vec2(doiter(z+vec2(d,0),p)-v,doiter(z+vec2(0,d),p)-v)/d;
	vec4 c = vec4(.1,.2,1.,1.)*doiter(z+dd/v,p);
	gl_FragColor=c;
}