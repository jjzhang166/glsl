//MG
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*10.0;
	p.x-=resolution.x/resolution.y*5.0;p.y-=5.0;
	float dist;
	float a1,a2,b1,b2;
	
	for (int i=0;i<52;i++) {
		a1=p.x-sin(time-float(i)/20.0)*2.0;
		a2=p.x-sin(time-float(i)/20.0)*2.0;
		b1=p.y-cos(time-float(i)/20.0)*2.0;
		b2=p.y-cos(time-float(i)/20.0)*2.0;
		dist=(0.1/float(i+1))/sqrt(a1*a2+b1*b2);
		gl_FragColor+=vec4(dist,dist,dist,1.0);
		
		a1=p.x-sin(time-float(i)/20.0+3.14159)*2.0;
		a2=p.x-sin(time-float(i)/20.0+3.14159)*2.0;
		b1=p.y-cos(time-float(i)/20.0+3.14159)*2.0;
		b2=p.y-cos(time-float(i)/20.0+3.14159)*2.0;
		dist=(0.1/float(i+1))/sqrt(a1*a2+b1*b2);
		gl_FragColor-=vec4(dist,dist,dist,1.0);
	}
	
	gl_FragColor+=vec4(0.5,0.5,0.5,1.0);
}