#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//another old one that's a few years old, from me mucking about with the massive clod premise after seeing psonice set it up for QC. :D This is converted to webGl.-georgetoledo
// float u,x,y,booyah,donut
const float booyah =20.;
const float donut =3.0;
float f(vec3 o){	
	float a=(sin(o.x)*cos(o.y))*booyah;
	o=vec3(sin(a)/o.x*cos(a)*o.y,cos(a)*o.x*sin(a)*o.y,(sin(a)*o.x/cos(a)*o.y))*(sin(a)*o.y*cos(a)*o.x);
	return dot(cos(o)+sin(o),vec3(1.5))-donut;
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
			return vec3(mix( ((max(-dot(n,vec3(1.0)),1.0) + 1.0*max(-dot(n,vec3(-.9,-.5,-.4)),0.)))*(mod(length(p.xy)*.1,0.5)<1.0?vec3(.3,.2,.1):vec3(.0,1.0,1.0)),vec3(.3,.1,.1),vec3(pow(t/25.,1.0))));
		}
		t+=3.8
	;
	}
	return vec3(1.0,1.0,1.0);
}

//adding some fisheye. -gtoledo

vec2 barrelDistortion(vec2 coord) {

	vec2 cc = coord;// - 0.5;

	float dist = dot(cc, cc);

	return coord + cc * (dist * dist) * 1.5;

    }

 

 


void main(){
	vec2 vPos=(-1.0+2.0*((gl_FragCoord.xy)/resolution.xy)) * 0.33;	
	float t=dot(gl_FragColor.xyz,vec3(1.0,1.0,1.0))*1.0;
	vec4 color=vec4(s(vec3(vec2(cos(time)*1.1,sin(time)*1.1),time*5.), normalize(vec3((gl_FragCoord.xy-vec2(resolution.xy/2.))/vec2(resolution.xy),1.0*sin(time*.1)+1.5))),1.);
	gl_FragColor=color;

	float d = distance(vPos, vec2(.0,.0));
	float l = ( 1.0 - length( vPos * 0.25 ) );
  	gl_FragColor.rgb *= smoothstep(.4, .1, d)*2.1;//vignette and blare out -gt
	gl_FragColor.rg += mod( gl_FragCoord.y, .2 );
	gl_FragColor.b += mod( gl_FragCoord.y, .3 );	//lines after vignetting -gt
	
}











