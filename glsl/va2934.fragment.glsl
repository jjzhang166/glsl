precision lowp float;
#define f float
#define n normalize
#define v vec3
 
uniform vec2 resolution;
uniform f time;
f t=time/10.;
 
f b(v p,v b){
		v q=abs(p)-b;
		return min(max(q.x,max(q.y,q.z)),length(max(q,0.)));
}
 
f h(v p){
		v q=v(2.5),a,r,k=v(1e2,1,0);
		p=mod(p,q)-q/2.;
		f d=b(p,v(1)),s=1.;
		for(int i=0;i<3;i++){
				a=mod(p*s,2.)-1.;
				s*=(2.+t)/3.;
				r=1.5-3.0*abs(a);
				d=max(d,-min(b(r,k.xyy),min(b(r.yzx,k.yxy),b(r.zxy,k.yyx)))/s);
		}
		return d;
}
 
void main(){
		vec2 q=-1.+2.*gl_FragCoord.xy/resolution;
		q.x*=resolution.x/resolution.y;
		f d=0.;
		v p=v(.1*sin(t),.5,6.*t),
		w=n(-p),u=n(cross(v(cos(6.*t),sin(6.*t),0),w)),
		r=n(q.x*u+q.y*n(cross(w,u))+w);
		for(int i=0;i<64;i++){
				d=h(p)-.001;
				if(d<.001)break;
				p+=r*d/4.;
		}
	   
		d=0.;
		for(f i=0.;i<9.;i++)
				d+=h(p+v(cos(i),sin(i),-cos(i))/4.);
	   
		t<1.?d*=t:d;
		gl_FragColor=vec4(h(p+.1)*v(1,.4,.2)*d*d,1);
}