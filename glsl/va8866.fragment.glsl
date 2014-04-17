#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// I couldn't resist playing around with Kali's "Cosmos" shader!
//https://www.shadertoy.com/view/MssGD8

float tim = (time) * 60.0;

void main(void)
{
	float s=0.,v=0.;
	for (int r=0; r<140; r++) {
		vec3 p=vec3(.3,.2,floor(time*20.)*.005)
		 +s*vec3(gl_FragCoord.xy*.00003-vec2(.01,.005),1.);
		p.z=fract(p.z);
		for (int i=0; i<18; i++) p=abs(p)/dot(p,p)*2.-1.;
		v+=length(p*p)*(.7-s)*.0015;
		s+=.005;
	}
	gl_FragColor = v*vec4(1.,.7,v*1.5,1.);	
}