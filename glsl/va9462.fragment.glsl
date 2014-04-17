#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(  ) {
	vec2 p =(8.0*( gl_FragCoord.xy / resolution.xy )-4.0) ;
	vec2 c=2.0*vec2(cos(time*0.2),sin(time*0.2));	
	
	//l'inversion
	p=(p-c)/dot(p-c,p-c);
	//RGB
	float r=mod(exp(p.x*p.y),exp(p.y+time));
	float g=mod(exp(dot(p,c)),exp(p.x)*exp(p.y));
	float b=cos(time+p.y)*mod(exp(p.x*p.y),exp(p.x+time));
		
	gl_FragColor = vec4 (-1.0+2.0*clamp(abs(vec3(r,g,b )),0.2,1.) , 1.);
}