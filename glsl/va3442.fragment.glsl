#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//uniform float u,x,y;
//more old riffin' on version of the massive clod that psonice showed me setup for qc. some of this stuff is from when I was "figuring stuff out" so there may be atrocities. setting it up for webGL.-georgetoledo
float f(vec3 o){	
	float a=(cos(o.x)+o.y*.95)*.75;
	o=vec3(sin(a)*o.x-tan(a)*o.y,cos(a)*o.x+tan(a)*o.y,o.z);
	return dot(cos(o)*cos(o),vec3(1.5))-1.;
}

vec3 s(vec3 o,vec3 d){
	float t=0.,a,b;
	for(int i=0;i<450;i++){
		if(f(o+d*t)<0.01){
			a=t-.0125;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*.5);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(.01,.1,.3),p=o+d*t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*3.14)))*.1);
			return vec3(mix( ((max(-dot(n,vec3(.3)),-10.) + 0.125*max(-dot(n,vec3(-.1,-.1,0)),0.)))*(mod(length(p.xy)*.2,1.)<1.0?vec3(.1,.1,.5):vec3(.79,.3,.4)),vec3(1.3,.1,.1),vec3(pow(t/53.,1.))));
		}
		t+=.23
	;
	}
	return vec3(.1,.1,.0);
}

void main(){
	//float ox=x*1.0;
	//float oy=y*1.0;
	//float t=dot(gl_Color.xyz,vec3(.1,1.,.1))*.1;
	gl_FragColor=vec4(s(vec3(cos(time*1.1)*.5,sin(time)*.10,time) * 3., normalize(vec3((gl_FragCoord.xy-vec2(resolution/2.))/vec2(resolution.x),.5))) * 4.,1);
}