#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main()
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	vec2 gr=vec2(0.1, 0.2);
	vec2 br=vec2(cos(time/2.0)*0.5+gr.x+sin(time*0.5), sin(time/2.0)*0.5+gr.y+cos(time*0.5));
	float distance = length(br-p);
	
	vec3 col=vec3(3.9*sin(p.x*distance*60.0+p.y*distance*50.0),
		      3.9*sin(p.x*distance*60.0+p.y*distance*60.0),
		      3.9*sin(p.x*distance*60.0+p.y*distance*60.0));
	gl_FragColor=vec4(col,1.0);
}
