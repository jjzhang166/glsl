#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float aspect = resolution.y/resolution.x;
	vec2 p = (( gl_FragCoord.xy / resolution.x )-vec2(0.5, 0.5*aspect));
	float d = (abs(p.x)+abs(p.y))*15.0;
	vec3 c;
	
	if(dot(p, p) > 0.03){
		d += time*1.0;	
	}
	else {
		d += time*8.0;
	}
	if(fract(d) > 0.5)
		c = vec3(1.0);
	else 
		c = vec3(0.0);
	float fd = fract(d);
	c = vec3(sin(abs(d)*2.0+0.8), sin(abs(d*4.5)+0.3), sin(abs(d*3.2)+0.5));
		
	
	gl_FragColor = vec4(c, 1.0);

}