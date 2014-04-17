//MG, edited by thp
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
	float dist,fx;
	vec2 q=gl_FragCoord.xy/resolution.xy;
	
	vec4 col=texture2D(backbuffer,q);
	gl_FragColor=col/1.07;
	
	fx=sin(p.x+time*10.5)+p.x/p.y;
	dist=0.005/abs(fx-p.y);
	gl_FragColor+=vec4(dist,4.0*dist,dist,1.0);
	
	fx=cos(p.x+time*10.)*2.0+p.y/p.x;
	dist=0.005/abs(fx-p.y);
	gl_FragColor+=vec4(4.0*dist,dist,dist,1.0);
}