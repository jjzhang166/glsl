#ifdef GL_ES
precision mediump float;
#endif

//another few years oldy that started from riffing on the massive clod. -george toledo
uniform float time;
uniform vec2 resolution;
float f(vec3 o){	
	float a=(sin(o.x)+o.y*100.0)*.005;
	o=vec3(cos(a)*o.x-tan(a)*o.y,cos(a)*o.x+tan(a)*o.y,o.z+tan(a)/sin(o)*cos(o)/cos(a));
	return dot(cos(o)+sin(a),vec3(.98))-.23;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<250;i++){
		if(f(o+d*t)<.01){
			a=t-5.0;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*.25);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(0.0,-1.0,-1.0),p=o+d*t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))-vec3((cos(p*3.14)))*1.3);
			return vec3(mix( ((max(-dot(n,vec3(.4)),-1.) - 1.0+max(-dot(n,vec3(-1.10,-.1,0)),0.)))*(mod(length(p.xy)*1.0,1.0)<1.0?vec3(.0,.3,.5):vec3(1.0,.5,.5)),vec3(1.,3.,12.1),vec3(pow(t/76.,1.0))));
		}
		t+=2.8
	;
	}
	return vec3(1.0,1.0,1.0);
}

void main(){
	float t=dot(gl_FragColor.xyz,vec3(1.0,.5,1.0))*1.0;
	gl_FragColor=vec4(s(vec3(cos(time*.1)*.1,sin(time)*.2,time), 
	normalize(vec3((2.*gl_FragCoord.xy-vec2(resolution.x,resolution.y))/vec2(resolution.x),1.0))),1);
}