// @paulofalcao
//
// Blue Pattern
//
// A old shader i had lying around
// Although it's really simple, I like the effect :)

// rotwang: yes, like it! @mod* something
#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2 resolution;

void main(void){
	vec2 u=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	float t=time*0.5;
	
	float tt=sin(t/4.0)*32.0;
	float x=u.x*tt+sin(t)*16.0;
	float y=u.y*tt+cos(t)*16.0;
	float c=sin(x)+sin(y);

	float xx=cos(t*0.7)*x-sin(t*0.7)*y;
	float yy=sin(t*0.7)*x+cos(t*0.7)*y;
	c=(sin(c+sin(xx)+sin(yy))+1.0)*0.5;
	c = smoothstep(0.4, 0.52, c);
	float mask = (1.0-length(u)*2.0);
	vec3 color = vec3(c*1.1,c*1.4,c*1.9) *mask;
	gl_FragColor=vec4(color,1.0);
}