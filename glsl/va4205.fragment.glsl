#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float aspect = resolution.y/resolution.x;
	vec2 p = (( gl_FragCoord.xy / resolution.x )-vec2(0.5, 0.5*aspect));
	float r = dot(p, p);
	float st = sin(time / 2.0), ct = cos(time / 2.0); 
	
	p.x = p.x * ct - p.y * st;
	p.y = p.x * st + p.y * ct;
	
	float d = log(abs(p.x)+abs(p.y))*15.0;
	vec3 c;
	
	
	if(r < 0.05 || r > 0.2) {
		d -= time*8.0;
	}
	else {
		d = -d - time*12.0;
		
	}
	
	c = vec3(sin(d * 2.0), sin(d * 2.0), cos(d * 4.0));
		
	
	gl_FragColor = vec4(c, 1.0);

}