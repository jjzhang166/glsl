#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float dist(vec2 p1, vec2 p2) 
{
	return length(p2-p1);	
}

vec2 lissajous(float t, float a, float b, float d) {
	return vec2(sin(a*t+d),sin(b*t));	
}

void main( void ) {

	vec2 pos= ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	pos.x *= resolution.x/resolution.y;
	vec2 m = mouse-0.5;
	m.x *= resolution.x/resolution.y;
	
	gl_FragColor = vec4(0.);
	float e1 = floor(mod((dist(pos,lissajous(time/25.,6.,7.,m.x))/0.1),2.0));
	float e2 = floor(mod((dist(pos,lissajous(time/20.,4.,5.,m.y))/0.1),2.0));
	float e3 = floor(mod((dist(pos,lissajous(time/30.,9.,11.,m.y))/0.1),2.0));
	float e4 = floor(mod((dist(pos,lissajous(time/25.,7.,4.,m.x))/0.1),2.0));
	float e5 = floor(mod((dist(pos,lissajous(time/18.,3.,6.,0.))/0.1),2.0));
	gl_FragColor = vec4(mod(e1+e2,2.0),mod(e5+e3,2.0),mod(e4+e2,2.0),1.0);
}