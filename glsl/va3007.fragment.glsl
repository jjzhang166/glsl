#ifdef GL_ES
precision highp float;
#endif

// Trying to get an antialiased checkerboard

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;


void main(void){
	vec2 p = gl_FragCoord.xy / resolution.xy;
	
	float x = pow(mod(p.x * 35., 1.0),25.0);
	if (mod(p.x * 35., 2.0)>1.0) x=1.0-x; 
	if (mod(p.y * 20., 2.0)>1.0) x=1.0-x; 
	
	gl_FragColor=vec4(x,x,x,1.0);
}
