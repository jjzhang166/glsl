// @paulofalcao
//
// Blue Pattern
//
// A old shader i had lying around
// Although it's really simple, I like the effect :)

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
void main(void)
{
	vec2 u=(gl_FragCoord.xy/resolution.x)*vec2(0.5,resolution.y/resolution.x)*mouse;
	
	float t=time*0.15;
	float tt=sin(t/5.0)*94.0;
	float x=u.x*tt+sin(t*.1)*4.0;
	float y=u.y*tt+cos(t*.3)*4.0;
	float c=cos(y)+sin(x);
	float zoom=sin(t);
	
	x=x;//*zoom/2.0+sin(t*10.1);
	y=y;//*zoom/2.0+cos(c*10.3);
	
	float xx=cos(t*0.7)*x-sin(t*0.7)*y;
	float yy=sin(t*0.7)*x+cos(t*0.7)*y;
	
	c=(sin(c+sin(xx)+sin(yy))+.80)*1.95;
	
	x=x*u.x;//x*zoom/2.0+sin(t*10.1);
	y=y*u.y;//*zoom/2.0+cos(c*10.3);
	
	float xx2=sin(t*0.7)*x-cos(t*0.7)*y*u.x;
	float yy2=cos(t*0.7)*x+sin(t*0.7)*y*u.x;
	float c2 = (cos(c+cos(xx2)+cos(yy2))+1.0);
	
	gl_FragColor=vec4((0.0+length(u)*1.0)*vec3(c*0.4,c*.4,c*0.4),1.0);
	gl_FragColor*=vec4(1.0,1.0,0.0,0.0)+vec4(c*0.0,c*0.0,c*1.0,1.0);
	
	gl_FragColor += mix(vec4(c*0.02,c*0.62,c*0.93,1.0),vec4(c2*0.82,c2*0.03,c2*0.07,1.0),0.5);
	
	gl_FragColor*=0.50;
	//gl_FragColor=vec4(1.0,1.0,1.0,1.0)-gl_FragColor;
}