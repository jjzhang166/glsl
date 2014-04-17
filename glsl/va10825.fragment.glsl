#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 tex(vec2 pos)
{
	float a = sin(pos.x/10.0)+sin(pos.y/10.0)+1.0;
	float b = fract(sin(dot(pos.xy ,vec2(12.9898,78.233))) * 43758.5453);
	float c = sin(pos.x/12.0)+sin(pos.y/12.0)+1.0;
	vec4 blahc = vec4(c,c*0.9,c*0.9,1.0);
	blahc = floor(blahc*2.0)/2.0;
	vec4 blah = vec4(a*0.9,a*0.9,a,1.0);
	blah = floor(blah);
	vec4 noise = vec4(b*0.9,b,b*0.9,1.0);	
	vec4 fac=vec4(sin(pos.y/100.0)/2.0+1.0, sin(pos.y/504.0)/2.0+1.0, sin(pos.y/814.0)/2.0+1.0, 1.0);
	return blah*fac.x+noise*fac.y+blahc*fac.z;
}

void main( void ) {

	vec2 pos = gl_FragCoord.xy+vec2(sin(time/4.0)*500.0,time*78.0+sin(time)*50.0);
	vec4 t = tex(pos);
	t *= vec4(cos(time/196.2)/2.0+1.0,(sin(time/83.53)/2.0+1.0),cos(time/169.0+100.0)/2.0+1.0,1.0);
	vec4 t2 = tex(vec2(pos.x-10.0,pos.y));
	vec4 t3 = tex(vec2(pos.x+10.0,pos.y));
	vec4 t4 = tex(vec2(pos.x,pos.y+10.0));
	vec4 t5 = tex(vec2(pos.x,pos.y-10.0));
	vec4 bloo = (t3*t2+t4+t5)/2.0;
	float fac = (cos(time))/4.0-0.8;
	gl_FragColor = (t/1.0+bloo*t2*fac);
}