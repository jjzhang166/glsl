//MG
// @mod* by rotwang
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
	
	float ga = 5.0;
	float ra = 3.0;
	for (int i=0;i<42;i++) {
		
		float ta = time-float(i)/ga;
		a1=p.x-sin(ta)*ra;
		a2=p.x-sin(ta)*ra;
		b1=p.y-cos(ta)*ra;
		b2=p.y-cos(ta)*ra;
		dist=(0.1/float(i+1))/sqrt(a1*a2+b1*b2);
		gl_FragColor+=vec4(dist,dist,dist,1.0);
		
		float tb = ta+(sin(time)*0.5+0.5)*6.283;
		
		a1=p.x-sin(tb)*ra;
		a2=p.x-sin(tb)*ra;
		b1=p.y-cos(tb)*ra;
		b2=p.y-cos(tb)*ra;
		dist=(0.1/float(i+1))/sqrt(a1*a2+b1*b2);
		gl_FragColor-=vec4(dist,dist,dist,1.0);
	}
	
	gl_FragColor+=vec4(0.5,0.5,0.5,1.0);
}