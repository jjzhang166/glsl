#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
//another one that started with messing with the clod. -george toledo
float f(vec3 o){	
	float a=(sin(o.x)*sin(o.y))*(5.0*sin(time*.5));
	o=vec3(sin(a)*o.x*cos(a)*o.y,cos(a)*o.x*sin(a)*o.y,(sin(a)*o.x*cos(a)*o.y))*(cos(a)*o.x/sin(a)*o.y);
	return dot(cos(o)+sin(o),vec3(1.5))-.1;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<250;i++){
		if(f(o+d*t)<1.0){
			a=t+1.0;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*1.0);
				if(f(o+d*t)<1.0)b=t;
				else a=t;
			}
			vec3 e=vec3(.0,.0,.0),p=o+d/t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((cos(p*1.14)))+1.0);
			return vec3(mix( ((max(-dot(n,vec3(.75)),.25) + 2.0*max(-dot(n,vec3(-2.0,-.1,0)),0.)))*(mod(length(p.xy)*.5,0.5)<1.0?vec3(.5,.4,.1):vec3(1.0,1.0,1.0)),vec3(.09,.04,.05),vec3(pow(t/40.,1.5))));
		}
		t+=3.8
	;
	}
	return vec3(1.0,1.0,1.0);
}

void main(){


	float t=dot(gl_FragColor.xyz,vec3(1.0,1.0,1.0));
	gl_FragColor=vec4(s(vec3(cos(time*1.1)*1.1,sin(time*.2)*1.2,1.), 
			    
	normalize(vec3((2.*gl_FragCoord.xy-vec2(resolution.x,resolution.y))/vec2(resolution.x),1.0))),1.);
}