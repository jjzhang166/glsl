#ifdef GL_ES
precision mediump float;
#endif
//another old clod spin off - george toledo
uniform float time;
uniform vec2 resolution;

float f(vec3 o){	
	float a=(tan(o.x)-o.y*1.1)*.001;
	o=vec3(tan(a)*o.x+cos(a)*o.y,sin(a)*o.x/tan(a)*o.y,sin(a)/tan(a)+o.z*51.0);
	return dot(cos(o)*cos(o),vec3(1.5))-5.0;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<666;i++){
		if(f(o+d*t)<.23){
			a=t-2.3;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*1.5);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(.1,1.5,1.3),p=o+d*t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))*vec3((sin(p*3.14)))*10.0);
			return vec3(mix( ((max(dot(n,vec3(1.0)),-1.) + 16.125*max(-dot(n,vec3(-1.1,-.1,0)),0.)))*(mod(length(p.xy)*.1,1.)<1.0?vec3(.1,.1,.5):vec3(.5,.3,.4)),vec3(1.0,.23,.0),vec3(pow(t/75.,2.3))));
		}
		t+=2.23*abs(sin(time)+1.)
	;
	}
	return vec3(1.1,.1,1.0);
}

void main(){


	float t=dot(gl_FragColor.xyz,vec3(1.1,.5,.1))*.23;
	gl_FragColor=vec4(s(vec3(cos(time*2.3)*1.1,sin(time*.25)*.23,time), 
	normalize(vec3((2.*gl_FragCoord.xy-vec2(resolution.x,resolution.y))/vec2(resolution.x),.1))),1);
}