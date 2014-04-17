//MG
// @mod* by rotwang
// backbuffer effect by @dist

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*10.0;
	p.x-=resolution.x/resolution.y*5.0;p.y-=5.0;
	float dist;
	float a1,a2,b1,b2;
	
	vec3 clra = vec3(1.0,0.6,0.2);
	vec3 clrb = vec3(0.2,0.6,1.0);
	vec3 clr;
	float ga = 4.0;
	float ra = 3.0;
	
	for (int i=0;i<42;i++) {
		
		float ta = time-float(i)/ga;
		a1=p.x-sin(ta)*ra;
		a2=p.x-sin(ta)*ra;
		b1=p.y-cos(ta)*ra;
		b2=p.y-cos(ta)*ra;
		dist=(0.2/float(i+1))/sqrt(a1*a2+b1*b2);
		clra+=vec3(dist,dist,dist);
		clra *= clrb*0.1;
		
		float tb = ta-(sin(time))*6.283*0.5;
		
		a1=p.x-sin(tb)*ra;
		a2=p.x-sin(tb)*ra;
		b1=p.y-cos(tb)*ra;
		b2=p.y-cos(tb)*ra;
		dist=(0.2/float(i+1))/-sqrt(a1*a2+b1*b2);
		clrb+=vec3(dist,dist,dist);
		
		
	}
	
		clr = clra-clrb;
	gl_FragColor=vec4(clr,1.0);
	gl_FragColor += texture2D(backbuffer, (gl_FragCoord.xy/resolution.xy+vec2(cos(time),sin(time*2.)))*0.97-vec2(cos(time),sin(time*2.)) ) * 0.75;
}