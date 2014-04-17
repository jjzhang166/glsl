// the.savage@hotmail.co.uk

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

uniform float time;

void main(void)
{
	vec2 vPixel=gl_FragCoord.xy;

	vec2 vScreen=resolution;
	vec2 vMouse=vec2(0.1,0.1)+mouse;

	float fTime=time*0.5;

	vec3 v=vec3(
		vPixel.x+vPixel.y+cos(sin(fTime)*2.0)*100.0+sin(vPixel.x/100.0)*100.0,
		vPixel.y/vScreen.y/(vMouse.x*5.0)+fTime,
		vPixel.x/vScreen.x/(vMouse.y*5.0));
	
	float r=abs(sin(v.y+fTime)/2.0+v.z/2.0-v.y-v.z+fTime);
	float g=abs(sin(r+sin(v.x/1000.0+fTime)+sin(vPixel.y/100.0+fTime)+sin((vPixel.x+vPixel.y)/100.0)*3.0));
	float b=abs(sin(g+cos(v.y+v.z+g)+cos(v.z)+sin(v.x/1000.0)));

	gl_FragColor=vec4(r,g,b,1.0);
}
