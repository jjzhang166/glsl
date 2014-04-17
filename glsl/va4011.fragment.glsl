#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 a=mouse* resolution;
	vec2 b=vec2(10.0,20.0);
	
	vec2 fc=vec2(0,0);//;
	float ang=-atan((b.y-a.y)/(b.x-a.x));
	fc.x=(gl_FragCoord.xy.x-b.x)*cos(ang)-(gl_FragCoord.xy.y-b.y)*sin(ang);
	fc.y=(gl_FragCoord.xy.x-b.x)*sin(ang)+(gl_FragCoord.xy.y-b.y)*cos(ang);
	
	float y=200.0*sin(fc.x/2000.0+time/2.0);
	
	float R=abs(fc.y-y);
	gl_FragColor = vec4(1.0*(sin(time)*10.93+0.97)/R, 0.0,abs(tan(time/10.0)/R)/10.5, 19.0); 
}