#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

//This is a few years old. It started as a massive mucking about with the "massive clod" shader port to QC that psonice shared, tweaking stuff before I had any clue what I was doing, and before webGL even existed! So, don't use it as an example of good coding. - george toledo

float f(vec3 o){	
	float a=((cos(o.x))/sin(o.y)+cos(time)+20.)*sin(time*.0001);
	o=vec3(sin(a)*o.x*cos(a)*o.y,cos(a)*o.x/tan(a)*o.y,o.z+cos(a)*(sin(a)/cos(a)*.333));
	return dot(cos(o)*cos(o),vec3(1.5))-2.0;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<250;i++){
		if(f(o+d*t)<.1){
			a=t+1.0;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*1.0);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(0.0,0.0,0.0),p=o+d/t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))-vec3((cos(p*1.)))+1.);
			return vec3(mix( ((max(-dot(n,vec3(1.0)),-10.) / 10.0*max(-dot(n,vec3(.01,0.0,.5)),0.)))*(mod(length(p.xy)*1.5,1.5)<1.0?vec3(1.5,.1,.9):vec3(1.,1.0,1.0)),vec3(.25,.1,.0),vec3(pow(t/30.,1.0))));
		}
		t+=3.8
	;
	}
	return vec3(1.0,1.0,1.0);
}

void main(){
	
	float t=dot(gl_FragColor.xyz,vec3(1.0,0.1,1.0))*1.0;
	gl_FragColor=vec4(s(vec3(cos(time*.1)*.01,cos(time)*.1,time), 
			    
	normalize(vec3((2.*gl_FragCoord.xy-vec2(resolution.x,resolution.y))/vec2(resolution.x),1.0))),1.);
}