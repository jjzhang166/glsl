/*
Logo from http://thndl.com shader, by Andrew Baldwin (baldand@twitter)
*/
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 c=( vec2(resolution.x/resolution.y,1.)-4.*vec2(1.0,resolution.y/resolution.x)*gl_FragCoord.xy / resolution.xy );// + mouse / 4.0 - vec2(0.,.25);
	vec2 d=2.0/resolution.xy;
	float o=sin(time*3.141592654);
	vec2 b=vec2(c.x*cos(o)-c.y*sin(o), c.x*sin(o)+c.y*cos(o)); 
	float r,s,l,h,i,k,m,n;
	m=clamp(1.5-abs(b.y),0.2,1.5)+d.x*50.;
	i=step(-0.0,c.y);
	h=step(-0.0,b.y); 
	k=step(-1.0,b.y)*(1.-h)*(1.-smoothstep(0.027*m-d.x*1., 0.03*m,abs(b.x)));
	l=length(c);
	r=1.0-smoothstep(1.-d.x*2.,1.,l); 
	s=1.0-smoothstep(.5-d.x*2.,0.5,l); 
	float t=atan(c.x/c.y); 
	float u=(t+3.141*0.5)/3.141; 
	vec4 ryg=vec4(0.69*clamp(mix(vec3(.0,2.,0.), vec3(2.,0.,0.),u),0.0,1.0),2.4-2.*l); 
	vec4 tg=mix(vec4(ryg.rgb,0.),ryg,r); 
	n=clamp(1.75*l-0.75,0.,1.);
	vec4 bg=mix(tg,vec4(0.,0.,0.,1.-n),i);
	float v=atan(c.x,c.y); 
	n=.9+.1*sin((20.*l+v)*5.); 
	vec4 w=vec4(n,n,n,1.); 
	vec4 e=mix(bg,w*vec4(vec3(abs(mod(v+3.141*0.75, 2.*3.141)/3.141-1.)),1.),s); 
	lowp vec4 f=mix(e,vec4(vec3(1.-(30.*abs((b.x/m+0.01)))),1.),k);
	f=mix(vec4(0.2),f,f.a);
	gl_FragColor = f;
}