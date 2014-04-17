#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(  ) {
	vec2 p =(4.0*( gl_FragCoord.xy / resolution.xy )-2.0) ;
	p=(p*sin(time*0.2)+vec2(sin(time*0.1),cos(0.5*time)))/dot(p-cos(time*0.1),p+sin(time*0.2));
	p=p/dot(p+cos(time*0.1),p+sin(time*0.1));
	vec3 coul= vec3(0.2*sin(time)*mod(p.x-time,p.y),mod(exp(p.x*p.y),p.x+p.y), ( mod(p.y+time,p.x)));	
	gl_FragColor = vec4 (clamp(abs(coul),0.,0.8) , 0.95);
}
