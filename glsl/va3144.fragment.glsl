#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//riffing on massive clod type deal. -gtoledo

float f(vec3 o){	
	float a=(sin(o.x)/o.y*100.0)*.01;
	o=vec3(cos(a)*o.x*cos(a)*o.y,sin(a)*o.x+sin(a)*o.y,o.z);
	return dot(cos(o)*cos(o),vec3(.8))-1.0;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<250;i++){
		if(f(o+d*t)<0.001){
			a=t-1.125;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*.23);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(0.0,0.0,0.0),p=o+d*t,n=normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.xyx))+vec3((cos(p*1.14)))*5.1);
			return vec3(mix(((max(dot(n,vec3(.5)),.5)*1.125*max(dot(n,vec3(1.1,.1,1.0)),0.25)))*(mod(length(p.xy)*6.5,1.1)<1.0?vec3(0.2,0.4,0.5):vec3(1.,0.1,0.2)),vec3(1.0,1.0,0.1),vec3(pow(t/56.0,1.2))));
		}
		t+=1.*sin(time*.1)+3.
	;
	}
	return vec3(1.1,1.1,1.0);
}

void main(){

	gl_FragColor=vec4(s(vec3(cos(time*.1)*.5,sin(time)*.1,time), 
	normalize(vec3((gl_FragCoord.xy-vec2(resolution/2.))/vec2(resolution),0.5))),1.);
}