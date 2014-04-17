#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float linesize = 0.002;
const float linedist = 0.05;
const float linealpha = 0.65;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p.y *= resolution.y/resolution.x;
	//p.y += sin(time+p.x+mouse.y)*0.2;
	//p.x += sin(time+p.y+mouse.x)*0.2;
	float color = 0.;
	
	color += ceil((mod(p.x,linedist)-(linedist-linesize)))*linealpha;
	color += ceil((mod(p.y,linedist)-(linedist-linesize)))*linealpha;
	
	vec3 c = vec3(sin(time)+1.*color,cos(time)+1.*color,asin(time)*color);
	
	gl_FragColor = vec4(c, 0);
}