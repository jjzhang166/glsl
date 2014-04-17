#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//another old one that's a few years old, from me mucking about with the massive clod premise after seeing psonice set it up for QC. :D This is converted to webGl.-georgetoledo
// float u,x,y,booyah,donut
uniform float u,x,y;

float f(vec3 o){	
	float a=(cos(o.x)-o.y*2.5)*.1;
	o=vec3(cos(a)*o.x-cos(a)+o.y,sin(a)*o.x*sin(a),o.z);
	return dot(cos(o)*cos(o),vec3(1.5))-1.5;
}

vec3 s(vec3 o,vec3 d){
	float t=1.,a,b;
	for(int i=0;i<450;i++){
		if(f(o+d*t)<0.05){
			a=t-.5;
			b=t;
			for(int i=0; i<1;i++){
				t=((a+b)*.5);
				if(f(o+d*t)<0.)b=t;
				else a=t;
			}
			vec3 e=vec3(.1,.1,.3),p=o+d*t,n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*3.14)))*10.0);
			return vec3(mix( ((max(-dot(n,vec3(1.0)),-1.) + 0.125*max(-dot(n,vec3(.1,1.1,0)),0.)))*(mod(length(p.xy)*.2,1.)<1.0?vec3(.1,.3,.5):vec3(.2,.8,.1)),vec3(1.,.1,.1),vec3(pow(t/55.,1.))));
		}
		t+=.23
	;
	}
	return vec3(.1,.1,1.0);
}

void main(){
		vec2 vPos=(-1.0+2.0*((gl_FragCoord.xy)/resolution.xy)) * 0.33;	
	float ox=x*1.0;
	float oy=y*1.0;
	float t=dot(gl_FragColor.xyz,vec3(1.1,.5,.1))*.1;
	vec4 color=vec4(s(vec3(cos(u*.1)*.1,sin(time)*.2,time), normalize(vec3((gl_FragCoord.xy-vec2(resolution.xy/2.))/vec2(resolution.x),.1))),1);
gl_FragColor=color;

	float d = distance(vPos, vec2(.0,.0));
	float l = ( 1.0 - length( vPos * 0.25 ) );
  	gl_FragColor.rgb *= smoothstep(.4, .1, d)*2.1;//vignette and blare out -gt
	gl_FragColor.rg += mod( gl_FragCoord.y, .2 );
	gl_FragColor.b += mod( gl_FragCoord.y, .3 );	//lines after vignetting -gt
	
}

 

 






