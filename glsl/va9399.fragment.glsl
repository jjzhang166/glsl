
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(  ) {
	vec2 p =(2.0*( gl_FragCoord.xy / resolution.xy )-1.0) ;
	p=(p*cos(time))/dot(p,p)+sin(time);
	vec3 coul= vec3(sin(time)*mod(p.x+time,p.y),mod(exp(p.x*p.y),p.x+p.y), ( mod(p.y+time,p.x)));	
	gl_FragColor = vec4 (clamp(abs(coul),0.1,1.) , 1.0);
	}