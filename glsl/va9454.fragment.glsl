                           
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(  ) {
	vec2 p =(8.0*( gl_FragCoord.xy / resolution.xy )-4.0) ;
	p=(p*cos(time*0.2)+vec2(sin(time*0.1),cos(0.5*time)))/dot(p-cos(time*0.1),p+sin(time*0.2));
	p=p/dot(p+cos(time*0.1),p+sin(time*0.1));
	vec3 coul= vec3(mod(exp(p.x*p.y),exp(p.y+p.x)),mod(pow(p.x/p.y,p.y+cos(time)),sin(time)), mod(exp(p.x+p.y),exp(p.y*p.x)));	
	gl_FragColor = vec4 (-1.0+2.0*clamp(abs(coul),0.2,1.) , 1.);
}
