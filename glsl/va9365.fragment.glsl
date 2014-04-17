#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(  ) {

	vec2 p = abs(2.0*( gl_FragCoord.xy / resolution.xy )-1.0) +1.5*cos(time);	
	vec3 coul= vec3(1.0*cos(time)*mod(p.x*time*0.5,p.y),0.1, 1.0*cos(time*0.7) *( mod(p.y*time,p.x)));	
	gl_FragColor = vec4 (clamp(abs(coul),0.1,1.) , 1.0);

	}