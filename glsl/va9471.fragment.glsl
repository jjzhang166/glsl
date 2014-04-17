#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(  ) {
	vec2 p =(8.0*( gl_FragCoord.xy / resolution.xy )-4.0) ;
	vec2 c=2.0*vec2(cos(time*0.2),sin(time*0.2));	
	
	//mix inversion , scale
	p=(p-c)/dot(p-c,p-c)-0.2*(p/c) ;
	//RGB
	float r= mod(exp(p.y/p.x),exp(p.y));
	float g=mod(exp(dot(p,c*p)),exp(p.x));
	float b=mod(exp(cos(time)),exp(p.x));
		
	gl_FragColor = vec4 (-1.0+2.0*clamp(abs(vec3(r,g,b )),0.1,1.) , 1.);
}