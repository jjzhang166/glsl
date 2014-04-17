// fuck that shit.

// original found at https://www.shadertoy.com/view/MsfGzM

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f(vec3 p) 
{ 
	p.z+=time*0.15+sin(time*0.6)*0.3;
	p.x+=sin(time*1.1)*0.2;
	p.y+=cos(time*0.4)*0.5;
	return length(.05*cos(9.*p.y*p.x)+cos(p)-.1*cos(9.*(p.z+.3*p.x-p.y)))-(sin(time*0.25)*0.05+0.05+1.0); 
}

void main( void ) {
	vec3 d=.5-gl_FragCoord.xyz/resolution.x,o=d;for(int i=0;i<9;i++)o+=f(o)*d*(sin(time*0.6)*0.3+0.3+1.0);
	vec4 c = vec4(abs(f(o-d+cos(time*0.1)*5.0)*vec3(.0,.0,.12)+f(o-vec3(sin(time*0.5)*0.1+5.4))*vec3(.25,.0012,.341))*(5.-o.z),1.);
	c.r *= mod(gl_FragCoord.y, 2.0);
	gl_FragColor=c;
}